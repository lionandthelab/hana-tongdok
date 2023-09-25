import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/src/constants/app_sizes.dart';
import 'package:starter_architecture_flutter_firebase/src/features/keeps/domain/keep.dart';

class KeepListItem extends StatelessWidget {
  const KeepListItem({
    super.key,
    required this.keep,
    this.onTap,
  });

  final Keep keep;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.p16,
          vertical: Sizes.p8,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final String title = keep.title;
    final String verse = keep.verse;
    final String note = keep.note;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(title,
              style: const TextStyle(fontSize: 18.0, color: Colors.grey)),
          gapW16,
          Text(verse, style: const TextStyle(fontSize: 18.0)),
        ]),
        if (keep.note.isNotEmpty)
          Text(
            keep.note,
            style: const TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
      ],
    );
  }
}

class DismissibleKeepListItem extends StatelessWidget {
  const DismissibleKeepListItem({
    super.key,
    required this.dismissibleKey,
    required this.keep,
    this.onDismissed,
    this.onTap,
  });

  final Key dismissibleKey;
  final Keep keep;
  final VoidCallback? onDismissed;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: dismissibleKey,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed?.call(),
      child: KeepListItem(
        keep: keep,
        onTap: onTap,
      ),
    );
  }
}
