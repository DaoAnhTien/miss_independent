import '../../../common/utils/utils.dart';
import '../../../common/utils/validator.dart';
import '../../../generated/l10n.dart';

class VerifyEmailValidator {
  static String? codeValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.verifyCodeIsRequired;
    }
    return null;
  }
}

class CreateProfileValidator {
  static String? businessEmailValidation(String? value) {
    if (!Validator.isNullOrEmpty(value) && !Validator.isEmailValid(value)) {
      return S.current.invalidEmail;
    }
    return null;
  }

  static String? businessNameValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.businessNameIsRequired;
    }
    return null;
  }

  static String? nameValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredName;
    }
    return null;
  }

  static String? aboutMeValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.aboutMeIsRequired;
    }
    return null;
  }
}

class CommentPostValidator {
  static String? commentValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredComment;
    }
    return null;
  }
}

class CheckoutValidator {
  static String? phoneValidation(String? value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{6,15}$';
    RegExp regex = RegExp(pattern);
    if (value?.isEmpty == true) {
      return S.current.requiredPhoneNumber;
    }
    if (!regex.hasMatch(value ?? "")) {
      return S.current.invalidPhoneNumber;
    }
    return null;
  }

  static String? countryValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredCountry;
    }
    return null;
  }

  static String? stateValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredState;
    }
    return null;
  }

  static String? cityValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredCity;
    }
    return null;
  }

  static String? addressValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredAddress;
    }
    return null;
  }

  static String? zipCodeValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredZipCode;
    }
    return null;
  }
}

class ReportValidator {
  static String? reasonValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredReason;
    }
    return null;
  }
}

class AddProductValidator {
  static String? priceValidator(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredPrice;
    }
    String? invalid = Validator.doubleValidation(value);
    if (invalid != null) {
      return invalid;
    } else if ((parseDouble(value!) ?? 0) < 0) {
      return S.current.thePriceMustBeGreaterThanZero;
    }
    return null;
  }

  static String? weightValidator(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredWeight;
    }
    String? invalid = Validator.doubleValidation(value);
    if (invalid != null) {
      return invalid;
    } else if ((parseDouble(value!) ?? 0) < 0) {
      return S.current.theWeightMustBeGreaterThanZero;
    }
    return null;
  }

  static String? descriptionValidator(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredDescription;
    }
    return null;
  }

  static String? categoryValidator(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredCategory;
    }
    return null;
  }

  static String? quantityValidator(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredQuantity;
    }
    String? invalid = Validator.intValidation(value);
    if (invalid != null) {
      return invalid;
    } else if ((parseInt(value!) ?? 0) < 0) {
      return S.current.theQuantityMustBeGreaterThanZero;
    }
    return null;
  }

  static String? nameValidator(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredName;
    }
    return null;
  }

  static String? skuValidator(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return S.current.requiredSku;
    }
    return null;
  }
}
