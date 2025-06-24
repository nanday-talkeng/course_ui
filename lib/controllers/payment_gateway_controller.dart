import 'dart:developer';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentController extends GetxController {
  Razorpay? _razorpay;

  @override
  void onInit() {
    super.onInit();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void onClose() {
    _razorpay?.clear(); // Clean up
    super.onClose();
  }

  void openCheckout({
    required String name,
    required String contact,
    required String email,
    required int amountInPaise,
    String description = '',
    String orderId = '',
  }) {
    if (_razorpay == null) {
      log("Razorpay is not initialized");
      return;
    }

    var options = {
      'key': 'rzp_test_YourKeyHere', // Replace with your actual key
      'amount': amountInPaise,
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm'],
      },
    };

    if (orderId.isNotEmpty) {
      options['order_id'] = orderId;
    }

    try {
      _razorpay!.open(options);
    } catch (e) {
      log('Razorpay open error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    log('✅ Payment Successful: ${response.paymentId}');
    // Handle success logic
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log('❌ Payment Failed: ${response.code} | ${response.message}');
    // Handle failure logic
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log('💰 External Wallet Selected: ${response.walletName}');
    // Handle wallet logic
  }
}
