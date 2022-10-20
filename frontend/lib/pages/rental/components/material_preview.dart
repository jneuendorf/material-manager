import 'package:flutter/material.dart';

import 'package:frontend/extensions/material/material.dart';


class MaterialPreview extends StatelessWidget {
  final MaterialModel item;

  const MaterialPreview({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(4.0),
    child: AspectRatio(
      aspectRatio: 1.0,
      child: InkWell(
        onTap: () {},
        hoverColor: Colors.black,
        child: Card(
          color: Colors.white,
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Column(
              children: [
                Expanded(
                  child: Image.network('https://picsum.photos/250?image=9'),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${item.equipmentTypes.first.description}, ${item.properties.first.value} ${item.properties.first.unit}'),
                      Text('${item.rentalFee} €'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}