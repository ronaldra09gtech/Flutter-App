import 'package:flutter/material.dart';
import 'package:plmclient/merchat/market/model/address.dart';
import 'package:plmclient/merchat/market/splashScreen/splashScreen.dart';

class NewOrderShipmentAddressDesign extends StatelessWidget
{
  final Address? model;
  final String? orderStatus;
  final String? orderID;
  final String? sellerID;
  final String? orderByUser;

  NewOrderShipmentAddressDesign({this.model, this.orderStatus, this.orderID, this.sellerID, this.orderByUser});



  @override
  Widget build(BuildContext context)
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
              'Shipping Details:',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.name!),
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    "Phone Number",
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(model!.phoneNumber!),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),


        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: InkWell(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreenMarket()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlueAccent,
                            Colors.blue,
                          ],
                          begin:  FractionalOffset(0.0, 0.0),
                          end:  FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        )
                    ),
                    width: MediaQuery.of(context).size.width - 220,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Accept",
                        style: const TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: InkWell(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const MySplashScreenMarket()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlueAccent,
                            Colors.blue,
                          ],
                          begin:  FractionalOffset(0.0, 0.0),
                          end:  FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        )
                    ),
                    width: MediaQuery.of(context).size.width - 220,
                    height: 50,
                    child: Center(
                      child: Text(
                        "Decline",
                        style: const TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20,),
      ],
    );
  }
}
