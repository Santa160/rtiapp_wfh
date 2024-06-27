// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:razorpay_web/razorpay_web.dart';
// import 'package:rtiapp/src/feature/user/home/service/rti.service.dart';

// var _service = RTIService();

// void handlePaymentSuccess(PaymentSuccessResponse response) async {
//   var order = {
//     "razorpay_order_id": response.orderId,
//     "razorpay_payment_id": response.paymentId,
//     "razorpay_signature": response.signature
//   };

//   var res = await _service.confirmResponsePayment(order);
//   if (res['success']) {
//     EasyLoading.showSuccess(res['message']);
//   }
// }

// void handlePaymentError(PaymentFailureResponse response) {}

// void handleExternalWallet(ExternalWalletResponse response) {}
