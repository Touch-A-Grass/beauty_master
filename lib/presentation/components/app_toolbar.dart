import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AppToolbar extends StatelessWidget {
  final Widget? title;
  final List<Widget> actions;

  const AppToolbar({super.key, this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: 44 + MediaQuery.of(context).padding.top,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).colorScheme.shadow, width: 1)),
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Stack(
        children: [
          if (title != null)
            Positioned.fill(
              child: Center(
                child: DefaultTextStyle(
                  style:
                      Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface) ??
                      const TextStyle(),
                  child: title!,
                ),
              ),
            ),
          if (AutoRouter.of(context).canPop())
            Positioned(
              left: 16,
              top: 0,
              bottom: 0,
              child: Center(child: BackButton(onPressed: () => context.maybePop())),
            ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ),
        ],
      ),
    );
  }
}
