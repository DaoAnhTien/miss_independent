import 'package:miss_independent/common/utils/extensions/interable_extension.dart';

class CheckoutRequest {
  CheckoutRequest(
      {this.phone,
      this.isCod,
      this.address,
      this.country,
      this.state,
      this.city,
      this.zipCode});

  final String? phone;
  final bool? isCod;
  final String? address;
  final String? country;
  final String? state;
  final String? city;
  final String? zipCode;

  factory CheckoutRequest.empty() => CheckoutRequest();
  
 factory CheckoutRequest.fromJson(Map<String?, dynamic> json) => CheckoutRequest(
        phone:json['phone'],
        address:json['address'],
        country:json['country'],
        state:json['state'],
        city:json['city'],
        zipCode:json['zip_code'],
        isCod: json["is_cod"] == 1,
      );
  CheckoutRequest copyWith({
    String? phone,
    bool? isCod,
    String? address,
    String? country,
    String? state,
    String? city,
    String? zipCode,
  }) {
    return CheckoutRequest(
      phone: phone ?? this.phone,
      isCod: isCod ?? this.isCod,
      address: address ?? this.address,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {
      "phone": phone,
      "is_cod": (isCod == true) ? 1 : 0,
      "address": address,
      "country": country,
      "state": state,
      "city": city,
      "zip_code": zipCode
    }..removeNull();
    return data;
  }
}
