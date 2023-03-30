import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/common/utils/toast.dart';
import 'package:miss_independent/data/local/datasource/order_local_datasource.dart';
import 'package:miss_independent/data/remote/order/request_model/checkout_request.dart';
import 'package:miss_independent/di/injection.dart';
import 'package:miss_independent/generated/l10n.dart';
import 'package:miss_independent/modules/order/bloc/checkout_cubit.dart';
import 'package:miss_independent/modules/order/bloc/checkout_state.dart';
import 'package:miss_independent/widgets/text_field.dart';
import '../../../common/theme/colors.dart';
import '../../../common/utils/utils.dart';
import '../../../widgets/button.dart';
import '../../auth/helpers/validator.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _formKey = GlobalKey<FormState>();

  // PhoneNumber? _phoneNumber;
  late final TextEditingController _addressController =
      TextEditingController(text: checkoutRequest.address);
  late final TextEditingController _phoneController =
      TextEditingController(text: checkoutRequest.phone);
  late final TextEditingController _countryController =
      TextEditingController(text: checkoutRequest.country);
  late final TextEditingController _stateController =
      TextEditingController(text: checkoutRequest.state);
  late final TextEditingController _cityController =
      TextEditingController(text: checkoutRequest.city);
  final FocusNode _countryFocus = FocusNode();

  late final TextEditingController _zipCodeController =
      TextEditingController(text: checkoutRequest.zipCode);
  late bool _isCod = checkoutRequest.isCod ?? false;
  late final CheckoutRequest checkoutRequest =
      _getCheckoutRequest() ?? CheckoutRequest.empty();
  CheckoutRequest? _getCheckoutRequest() {
    CheckoutRequest? item = getIt<OrderLocalDataSource>().getCheckoutRequest();
    return item;
  }

  @override
  void initState() {
    _countryFocus.addListener(() {
      if (_countryFocus.hasFocus) {
        showCountryPicker(
          context: context,
          showPhoneCode: false,
          onSelect: (Country country) {
            _countryController.text = country.name;
          },
        );
        _countryFocus.unfocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final agrs = context.getRouteArguments();
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).checkout),
      ),
      body: BlocProvider(
        create: (context) => getIt<CheckoutCubit>(),
        child: BlocConsumer<CheckoutCubit, CheckoutState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == RequestStatus.failed &&
                state.message?.isNotEmpty == true) {
              showErrorMessage(context, state.message!);
            }
            if (state.status == RequestStatus.success) {
              showSuccessMessage(context, S.of(context).orderSuccessfully);
              Navigator.of(context).popAndPushNamed(kOrderHistoryRoute);
            }
          },
          builder: (context, state) => SingleChildScrollView(
              child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            S.of(context).customerInformation,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        BasicTextField(
                          mandatory: true,
                          label: S.of(context).phoneNumber,
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: CheckoutValidator.phoneValidation,
                        ),
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Row(
                        //       children: [
                        //         Text(
                        //           S.of(context).phoneNumber,
                        //           style:
                        //               Theme.of(context).textTheme.labelMedium,
                        //         ),
                        //         const SizedBox(width: 1),
                        //         Text('*',
                        //             style: Theme.of(context)
                        //                 .textTheme
                        //                 .labelMedium
                        //                 ?.copyWith(color: Colors.red)),
                        //       ],
                        //     ),
                        //     const SizedBox(height: 10),
                        //     ClipRRect(
                        //       borderRadius: BorderRadius.circular(4),
                        //       child: IntlPhoneField(
                        //         keyboardType: TextInputType.phone,
                        //         disableLengthCheck: true,
                        //         initialValue: checkoutRequest.phone,
                        //         validator: CheckoutValidator.phoneValidation,
                        //         autovalidateMode:
                        //             AutovalidateMode.onUserInteraction,
                        //         decoration: const InputDecoration(
                        //           isDense: true,
                        //           border: InputBorder.none,
                        //           contentPadding: EdgeInsets.symmetric(
                        //               vertical: 15, horizontal: 10),
                        //           filled: true,
                        //         ),
                        //         onChanged: (value) {
                        //           _phoneNumber = value;
                        //         },
                        //         initialCountryCode: S.delegate.supportedLocales
                        //             .first.countryCode,
                        //       ),
                        //     ),
                        //   ],
                        // ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            S.of(context).deliveryInformation,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        BasicTextField(
                          mandatory: true,
                          focusNode: _countryFocus,
                          readOnly: true,
                          label: S.of(context).country,
                          validator: CheckoutValidator.countryValidation,
                          controller: _countryController,
                        ),
                        const SizedBox(height: 12),
                        BasicTextField(
                          mandatory: true,
                          label: S.of(context).state,
                          validator: CheckoutValidator.stateValidation,
                          controller: _stateController,
                        ),
                        const SizedBox(height: 12),
                        BasicTextField(
                          mandatory: true,
                          label: S.of(context).city,
                          validator: CheckoutValidator.cityValidation,
                          controller: _cityController,
                        ),
                        const SizedBox(height: 12),
                        BasicTextField(
                          mandatory: true,
                          label: S.of(context).address,
                          validator: CheckoutValidator.addressValidation,
                          controller: _addressController,
                        ),
                        const SizedBox(height: 12),
                        BasicTextField(
                          mandatory: true,
                          controller: _zipCodeController,
                          label: S.of(context).zipCode,
                          validator: CheckoutValidator.zipCodeValidation,
                        ),
                        Row(
                          children: [
                            Text(S.of(context).cashOnDelivery),
                            Checkbox(
                              value: _isCod,
                              onChanged: (value) {
                                setState(() {
                                  _isCod = !_isCod;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              const Divider(color: kGreyColor, thickness: 2, height: 12),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: kGreyColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "${S.of(context).items} (${agrs?['totalItem']})",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Container(
                      height: 50,
                      color: kGreyColor,
                      width: 1,
                    ),
                    Text.rich(TextSpan(
                        text: "${S.of(context).total}: ",
                        style: Theme.of(context).textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: formatCurrency(agrs?['totalPrice'] ?? 0),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                          )
                        ])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: BasicButton(
                  onPressed: () => _submitCheckout(context),
                  label: S.of(context).orderNow,
                  isLoading: state.status == RequestStatus.requesting,
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  void _submitCheckout(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      await context.read<CheckoutCubit>().placeOrder(checkoutRequest.copyWith(
            address: _addressController.text,
            phone: _phoneController.text.trim(),
            city: _cityController.text,
            country: _countryController.text,
            state: _stateController.text,
            isCod: _isCod,
            zipCode: _zipCodeController.text,
          ));
    }
  }
}
