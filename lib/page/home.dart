import 'package:cosmos/cosmos.dart';
import 'package:deprem_api/constant/const.dart';
import 'package:deprem_api/theme/color.dart';
import 'package:deprem_api/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controllerText = TextEditingController();
  List<List<String>> indexList = [];
  String title = "";
  List<Widget> widgets = [];
  late GoogleMapController mapController;
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> getApi() async {
    DepremAPI api = DepremAPI();
    await api.getApi().then((value) {
      List splitValue = value.toString().split(splitText);
      String currentText =
          splitValue[splitValue.length - 1].toString().split(splitTextPre)[0];
      List thisSplit = currentText.split("Ýlksel");
      for (String element in thisSplit) {
        if (element.length > 71) {
          String tarih = element.substring(0, 23).replaceAll("  ", "");
          String enlem = element.substring(23, 32).replaceAll(" ", "");
          String boylam = element.substring(31, 40).replaceAll(" ", "");
          String derinlik = element.substring(46, 55).replaceAll(" ", "");
          String ml = element.substring(60, 65).replaceAll(" ", "");
          String yer = element.substring(71, 120).replaceAll(" ", "");

          List<String> localIndex = [tarih, enlem, boylam, derinlik, ml, yer];
          indexList.add(localIndex);
          title = "$title\n$element";
        }
      }
    });
    print(indexList);
    for (List<String> element in indexList) {
      if (element[5].contains("(") && element[5].contains(")")) {
        widgets.add(
          depremWidget(
            // ignore: use_build_context_synchronously
            context,
            element[4],
            element[5].split("(")[1].split(")")[0],
            element[5].split("(")[0],
            element[1],
            element[2],
            element[0],
          ),
        );
      } else {
        widgets.add(
          depremWidget(
            // ignore: use_build_context_synchronously
            context,
            element[4],
            element[5],
            element[5],
            element[1],
            element[2],
            element[0],
          ),
        );
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "ByBug Earthquake",
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: width(context),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: bgLight.withOpacity(0.4),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: textColor.withOpacity(0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: TextField(
                        style: TextStyle(
                          color: textColor,
                        ),
                        maxLines: 1,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp("[a-zA-ZğĞüÜşŞıİöÖçÇ ]")),
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          labelText: "Ara",
                          labelStyle: TextStyle(
                            color: textColor.withOpacity(0.5),
                          ),
                        ),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                color: textColor.withOpacity(0.4),
                width: width(context),
                height: 2,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
              ),
              const SizedBox(height: 10),
              Column(
                children: widgets,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget depremWidget(
    BuildContext context,
    String ml,
    String title,
    String subtitle,
    String enlem,
    String boylam,
    String time,
  ) {
    Color color = bg.withOpacity(0.5);
    if (double.parse(ml) < 3.5) {
      color = bg.withOpacity(0.5);
    }
    if (double.parse(ml) > 3.5) {
      color = const Color.fromARGB(255, 119, 78, 17).withOpacity(0.5);
    }
    if (double.parse(ml) > 5) {
      color = const Color.fromARGB(255, 175, 108, 7);
    }
    if (double.parse(ml) > 5.5) {
      color = const Color.fromARGB(255, 177, 35, 25);
    }

    return GestureDetector(
      onTap: () {
        CosmosAlert.showCustomAlert(
          context,
          Container(
            width: width(context) * 0.8,
            height: height(context) * 0.7,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ),
            margin: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: bgLight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    width: width(context) * 0.8,
                    height: width(context) * 0.7,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: GoogleMap(
                        onMapCreated: onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target:
                              LatLng(double.parse(enlem), double.parse(boylam)),
                          zoom: 11.0,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: bg,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Şehir: ",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "$subtitle ($title)",
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: bg,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Enlem: ",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                enlem,
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: bg,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Boylam: ",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                boylam,
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: bg,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "Büyüklük (ML): ",
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                ml,
                                style: TextStyle(
                                  color: textColor.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
      child: Container(
        width: width(context),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5), color: bgLight),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                ml,
                style: TextStyle(
                  color: textColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                      Text(
                        "${time.replaceAll("\n", "").split(" ")[0].split(".")[2]}/${time.replaceAll("\n", "").split(" ")[0].split(".")[1]} •${time.replaceAll("\n", "").split(" ")[0].split(".")[0]}",
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "|",
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.access_time,
                        size: 12,
                        color: textColor.withOpacity(0.5),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${time.replaceAll("\n", "").split(" ")[1].split(":")[0]}:${time.replaceAll("\n", "").split(" ")[1].split(":")[1]}",
                        style: TextStyle(
                          color: textColor.withOpacity(0.5),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
