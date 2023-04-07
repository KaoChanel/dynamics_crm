import 'dart:async';

import 'package:dynamics_crm/models/debounce.dart';
import 'package:dynamics_crm/models/item.dart';
import 'package:dynamics_crm/providers/data_provider.dart';
import 'package:dynamics_crm/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:dynamics_crm/config/global_constants.dart';
import 'package:dynamics_crm/models/activity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'item_add_portrait.dart';

class ItemSelect extends ConsumerStatefulWidget {
  const ItemSelect({super.key, required this.type});

  final Activity type;

  @override
  ConsumerState<ItemSelect> createState() => _ItemSelectState();
}

class _ItemSelectState extends ConsumerState<ItemSelect> {
  ScrollController scroll = ScrollController();
  TextEditingController keyword = TextEditingController();
  late List<Item> allItems = ref.read(itemsFilter);
  final debouncer = Debouncer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(itemsFilter.notifier).addAll(ITEMS.take(35).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    allItems = ref.watch(itemsFilter);
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการสินค้า'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ITEMS = await ApiService().getItems();
          ref.read(itemsFilter.notifier).addAll(ITEMS.take(35).toList());
        },
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: TextFormField(
                    controller: keyword,
                    decoration: const InputDecoration(
                        hintText: 'ชื่อสินค้า, รหัสสินค้า, หน่วยนับ ...',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 10.0)
                    ),
                    onChanged: (String value) {
                      debouncer.call(() {
                        var filtered = ITEMS
                            .where((x) => x.description!.toLowerCase().contains(value.toLowerCase())
                            || x.no!.toLowerCase().contains(value.toLowerCase())
                          // || x.baseUnitOfMeasureCode!.toLowerCase().contains(value.toLowerCase())
                          // || (x.postCode != null ? x.postCode.contains(value) : false)
                        ).take(35).toList();

                        ref.read(itemsFilter.notifier).replace(filtered);
                      });
                    },
                  ),
                ),
                ListView(
                  primary: false,
                  shrinkWrap: true,
                  controller: scroll,
                  children: myItemList(),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.arrow_upward),
        onPressed: () {
          goToElement(1);
        },
      ),
    );
  }


  void goToElement(int index) {
    scroll.animateTo((100.0 * index),
        // 100 is the height of container and index of 6th element is 5
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut);
  }

  myItemList() {
    return allItems.map((e) {
      // bool inStock = hasStock(e.id);
      bool inStock = true;

      return Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                  ItemAddPortrait(type: widget.type, selectedItem: e)
              ));
            },
            child: Container(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 15.0, right: 15.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.no ?? '', style: const TextStyle(
                            fontSize: 14.0, color: Colors.black45)
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(e.description ?? '',
                                style: const TextStyle(fontSize: 16.0))
                        ),
                        Container(
                          child: e.inventory! > 0 ? const Text('พร้อมขาย',
                            style: TextStyle(color: Colors.lightGreen,
                                fontWeight: FontWeight.bold),) : Text(
                            'สินค้าหมด', style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),),
                        ),
                        // Text(e.goodUnitName ?? '', style: TextStyle(color: Colors.black54, fontSize: 14.0)),
                        SizedBox(
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                      child: const Icon(Icons.chevron_right_sharp,)
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }).toList() ?? Text('ไม่พบรายการสินค้า');
  }
}
