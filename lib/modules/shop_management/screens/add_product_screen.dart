import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_compression_flutter/image_compression_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miss_independent/common/enums/status.dart';
import 'package:miss_independent/common/theme/colors.dart';
import 'package:miss_independent/common/utils/extensions/build_context_extension.dart';
import 'package:miss_independent/data/local/datasource/category_local_datasource.dart';
import 'package:miss_independent/data/remote/product/request_models/update_product_request.dart';
import 'package:miss_independent/models/product.dart';
import 'package:miss_independent/modules/auth/helpers/validator.dart';
import 'package:miss_independent/widgets/cached_image.dart';
import '../../../common/utils/toast.dart';
import '../../../di/injection.dart';
import '../../../generated/l10n.dart';
import '../../../models/category.dart';
import '../../../widgets/button.dart';
import 'package:collection/collection.dart';

import '../../../widgets/text_field.dart';
import '../../services/widgets/select_category_field.dart';
import '../bloc/add_product_cubit.dart';
import '../bloc/add_product_state.dart';
import '../widgets/upload_image.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController =
      TextEditingController(text: product?.name);
  late final TextEditingController _skuController =
      TextEditingController(text: product?.sku);
  late final TextEditingController _categoryController =
      TextEditingController(text: _getCategoryName(product?.categoryId));
  late final TextEditingController _priceController =
      TextEditingController(text: product?.price?.toString());
  late final TextEditingController _weightController =
      TextEditingController(text: product?.weight?.toString());
  late final TextEditingController _descriptionController =
      TextEditingController(text: product?.description);
  late final TextEditingController _quantityController =
      TextEditingController(text: product?.quantity?.toString());
  int? _categoryId;
  XFile? _file;
  bool _showCurrentImg = true;
  final UpdateProductRequest _updateProductRequest =
      UpdateProductRequest.empty();
  Product? get product => context.getRouteArguments<Product>();
  late final isUpdate = product != null;

  String? _getCategoryName(int? id) {
    Category? item = getIt<CategoryLocalDatasource>()
        .getGeneralCategories()
        ?.firstWhereOrNull((e) => e.id == id);
    return item?.name ?? '';
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            isUpdate ? S.of(context).updateProduct : S.of(context).addProduct),
      ),
      body: BlocProvider<AddProductCubit>(
        create: (_) => getIt<AddProductCubit>()
          ..getCategories()
          ..init(product),
        child: BlocConsumer<AddProductCubit, AddProductState>(
            listener: (context, state) {
          if (state.status == RequestStatus.success &&
              state.message?.isNotEmpty == true) {
            showSuccessMessage(context, state.message!);
            Navigator.pop(context);
          } else if (state.status == RequestStatus.failed &&
              state.message?.isNotEmpty == true) {
            showErrorMessage(context, state.message!);
          }
        }, listenWhen: (previous, current) {
          return previous.status != current.status;
        }, builder: (BuildContext context, AddProductState state) {
          return SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 400),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            isUpdate
                                ? _buildUpdateImageMedia()
                                : _buildAddImageMedia(),
                            const SizedBox(height: 10),
                            BasicTextField(
                              mandatory: true,
                              controller: _nameController,
                              label: S.of(context).name,
                              validator: AddProductValidator.nameValidator,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              mandatory: true,
                              controller: _descriptionController,
                              label: S.of(context).description,
                              validator:
                                  AddProductValidator.descriptionValidator,
                            ),
                            const SizedBox(height: 10.0),
                            SelectCategoryField(
                                label: S.of(context).selectCategory,
                                categories: state.categories ?? [],
                                controller: _categoryController,
                                mandatory: true,
                                validator:
                                    AddProductValidator.categoryValidator,
                                onSelected: (Category category) {
                                  _categoryController.text =
                                      category.name ?? "";
                                  _categoryId = category.id;
                                }),
                            const SizedBox(height: 10),
                            BasicTextField(
                              controller: _skuController,
                              label: S.of(context).sku,
                            ),
                            const SizedBox(height: 10),
                            BasicTextField(
                              keyboardType: TextInputType.number,
                              mandatory: true,
                              controller: _priceController,
                              label: S.of(context).price,
                              validator: AddProductValidator.priceValidator,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: BasicTextField(
                                    keyboardType: TextInputType.number,
                                    controller: _weightController,
                                    mandatory: true,
                                    label: S.of(context).weight,
                                    validator:
                                        AddProductValidator.weightValidator,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: BasicTextField(
                                    validator:
                                        AddProductValidator.quantityValidator,
                                    keyboardType: TextInputType.number,
                                    controller: _quantityController,
                                    mandatory: true,
                                    label: S.of(context).quantity,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: BasicButton(
                    width: double.infinity,
                    isLoading: state.status == RequestStatus.requesting,
                    onPressed: () {
                      _submit(context, isUpdate: isUpdate);
                    },
                    label: isUpdate
                        ? S.of(context).update
                        : S.of(context).addProduct,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
      //
    );
  }

  Widget _buildAddImageMedia() {
    return _file == null
        ? UploadImage(
            onChanged: (XFile? file) {
              setState(() {
                _file = file;
              });
            },
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_file?.path ?? ""),
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _file = null;
                          });
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: kErrorRedColor,
                        ),
                      ))
                ],
              ),
            ],
          );
  }

  Widget _buildUpdateImageMedia() {
    return _showCurrentImg
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10, top: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedImage(
                        url: product?.image,
                        fit: BoxFit.cover,
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                  Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCurrentImg = false;
                          });
                        },
                        child: const Icon(
                          Icons.cancel,
                          color: kErrorRedColor,
                        ),
                      ))
                ],
              ),
            ],
          )
        : _buildAddImageMedia();
  }

  void _submit(BuildContext context, {bool isUpdate = false}) async {
    if (_formKey.currentState!.validate()) {
      if (isUpdate) {
        await context.read<AddProductCubit>().updateProduct(
            _updateProductRequest.copyWith(
                description: _descriptionController.text,
                categoryId: _categoryId,
                image: _file,
                name: _nameController.text,
                price: _priceController.text,
                quantity: _quantityController.text,
                weight: _weightController.text,
                sku: _skuController.text));
      } else {
        await context.read<AddProductCubit>().addProduct(
            _updateProductRequest.copyWith(
                categoryId: _categoryId,
                description: _descriptionController.text,
                image: _file,
                name: _nameController.text,
                price: _priceController.text,
                quantity: _quantityController.text,
                weight: _weightController.text,
                sku: _skuController.text));
      }
    }
  }
}
