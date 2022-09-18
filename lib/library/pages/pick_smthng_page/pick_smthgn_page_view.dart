import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:music_app/library/components/custom_textfield.dart';

import '../../components/custom_check_box.dart';
import '../../components/widget_song_small.dart';
import '../../models/model_song.dart';
import '../home_page/home_page_view.dart';

class PickSmthngPageView extends StatefulWidget {
  const PickSmthngPageView({Key? key, required this.items}) : super(key: key);

  final List items;

  @override
  State<PickSmthngPageView> createState() => _PickSmthngPageViewState();
}

class _PickSmthngPageViewState extends State<PickSmthngPageView> {
  List _items = [];
  List<int> selectedItemsIndex = [];

  final _title = "Pick";

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    _items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          Navigator.pop(context, selectedItemsIndex);
        },
        child: const Icon(Icons.check),
      ),
      body: Padding(
        padding: context.paddingNormal,
        child: Column(
          children: [
            CustomTextField.outlined(
              labelText: "Search",
              onChanged: _onSerach,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) => Row(
                  children: [
                    widget.items is List<ModelSong>
                        ? Expanded(
                            child: WidgetSongSmall(
                              song: _items[index],
                              onTap: () {},
                            ),
                          )
                        : const SizedBox(),
                    CustomCheckBox(
                      isListEmpty: selectedItemsIndex.isEmpty,
                      onCheckChane: (p0) {
                        if (p0) {
                          selectedItemsIndex.add(index);
                        } else {
                          selectedItemsIndex.remove(index);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onSerach(p0) {
    if (p0.trim() == "") {
      _loadItems();
      setState(() {});
      return;
    }

    if (_items is List<ModelSong>) {
      _items = (widget.items as List<ModelSong>)
          .where((element) => element.title!
              .toLowerCase()
              .replaceAll(" ", "")
              .contains(p0.toLowerCase().replaceAll(" ", "")))
          .toList();

      setState(() {});
    }
  }
}
