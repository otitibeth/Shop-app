import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routeName = '/edit-product';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey();
  // ignore: prefer_final_fields
  var _editedProduct =
      Product(id: '', title: '', description: '', imageUrl: '', price: 0);
  var _initValues = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': '',
  };

  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String?;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).FindById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    // if (_imageUrlFocusNode.hasFocus) {
    //   if ((!_imageUrlController.text.startsWith('http') &&
    //           !_imageUrlController.text.startsWith('https')) ||
    //       (!_imageUrlController.text.endsWith('.png') &&
    //           !_imageUrlController.text.endsWith('.jpg') &&
    //           !_imageUrlController.text.endsWith('.jpeg'))) {
    //     setState(() {});
    //   }
    //   setState(() {});
    // }
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    print('this is my edited product${_editedProduct.id}');
    if (_editedProduct.id == '') {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
      // Provider.of<Products>(context, listen: false).updateProductI(
      //   _editedProduct.id,
      //   _editedProduct,
      // );
    } else {
      Provider.of<Products>(context, listen: false).updateProduct(
        _editedProduct.id,
        _editedProduct,
      );
      // Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Products'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
            key: _form,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: const InputDecoration(label: Text('Title')),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_priceFocusNode),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter product title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                        title: value!,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price);
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: const InputDecoration(label: Text('Price')),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) => FocusScope.of(context)
                      .requestFocus(_descriptionFocusNode),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Enter a number greater than zero';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: _editedProduct.description,
                        imageUrl: _editedProduct.imageUrl,
                        price: double.parse(value!));
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: const InputDecoration(label: Text('Description')),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter product description';
                    }
                    if (value.length < 10) {
                      return 'Description must be atleast 10 characters long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                        isFavorite: _editedProduct.isFavorite,
                        id: _editedProduct.id,
                        title: _editedProduct.title,
                        description: value!,
                        imageUrl: _editedProduct.imageUrl,
                        price: _editedProduct.price);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      margin: const EdgeInsets.only(top: 15, right: 10),
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: Theme.of(context).primaryColor),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Text('Image')
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                              fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          label: Text('Image URL'),
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) => _saveForm,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter image URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Enter a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Enter a valid image URL';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedProduct = Product(
                              isFavorite: _editedProduct.isFavorite,
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              description: _editedProduct.description,
                              imageUrl: value!,
                              price: _editedProduct.price);
                        },
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: TextButton(
                        onPressed: () => _saveForm(),
                        child: const Text(
                          'Save',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
