
class PakiProxyBookingDetails
{
  String? bookID, clientUID, pickupaddress, price, phoneNum, status, notes, paymentmethod, orderTime, serviceType;
  double?  pickupaddresslng, pickupaddresslat;

  PakiProxyBookingDetails({
    this.serviceType,
    this.orderTime,
    this.notes,
    this.pickupaddress,
    this.pickupaddresslng,
    this.pickupaddresslat,
    this.clientUID,
    this.bookID,
    this.status,
    this.price,
    this.phoneNum,
    this.paymentmethod
  });
}