
class BookingDetails
{
  String? bookID;
  String? clientUID;
  String? riderUID;
  String? dropoffaddress;
  double? dropoffaddresslat;
  double? dropoffaddresslng;
  String? pickupaddress;
  double? pickupaddresslng;
  double? pickupaddresslat;
  String? notes;
  String? paymentmethod;
  String? orderTime;
  String? serviceType;
  String? status;
  String? phoneNum;
  String? price;

  BookingDetails({
    this.serviceType,
    this.dropoffaddress,
    this.dropoffaddresslat,
    this.dropoffaddresslng,
    this.orderTime,
    this.notes,
    this.pickupaddress,
    this.pickupaddresslng,
    this.pickupaddresslat,
    this.clientUID,
    this.riderUID,
    this.bookID,
    this.status,
    this.price,
    this.phoneNum,
    this.paymentmethod
  });
}