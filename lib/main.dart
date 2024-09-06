import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollview_observer/scrollview_observer.dart';
import 'package:scrollview_observer_test/message_list_cubit.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(providers: [
        BlocProvider<MessageListCubit>(
            create: (context) => MessageListCubit()..init(),
            child: const MainApp())
      ], child: const MainApp()),
    );
  }
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final ScrollController scrollController;
  late final ListObserverController observerController;
  late final ChatScrollObserver chatObserver;

  @override
  void initState() {
    scrollController = ScrollController();
    observerController = ListObserverController(controller: scrollController)
      ..cacheJumpIndexOffset = false;
    chatObserver = ChatScrollObserver(observerController)
      ..fixedPositionOffset = 8.0
      ..toRebuildScrollViewCallback = () {
        print('Rebuild scroll view');
        context.read<MessageListCubit>().resetMessages();
      };
    context.read<MessageListCubit>().observer = chatObserver;
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
              trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    context
                        .read<MessageListCubit>()
                        .createMessage(() => chatObserver.standby());
                  })),
          Expanded(
            child: ListViewObserver(
              controller: observerController,
              child: BlocBuilder<MessageListCubit, MessageListState>(
                  buildWhen: (previous, current) => current.status.isSuccess,
                  builder: (context, state) {
                    final items = state.items;
                    if (state.status == MessageListStatus.initial) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      print('Rebuild List: ${chatObserver.isShrinkWrap}');
                      return ListView.builder(
                          controller: scrollController,
                          reverse: true,
                          physics: ChatObserverClampingScrollPhysics(
                              observer: chatObserver),
                          shrinkWrap: chatObserver.isShrinkWrap,
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            if (scrollController.hasClients &&
                                (observerController.sliverContexts.isEmpty ||
                                    observerController.sliverContexts.first !=
                                        context)) {
                              observerController.reattach();
                              print('NEEDS REATTACH');
                            }
                            final itemIndex = index;
                            final reversedIndex = items.length - itemIndex - 1;
                            final item = items[reversedIndex];
                            return ListTile(
                                title: Text(item.text),
                                leading: const Icon(Icons.message));
                          });
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
