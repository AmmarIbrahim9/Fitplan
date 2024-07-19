// table_service.dart
class TableService {
  String determineTableName(String? bmiCategory, String medicalCondition, String? eatingSystem) {
    if (bmiCategory == null || eatingSystem == null) {
      return ''; // Handle default case
    }

    switch (bmiCategory) {
      case 'underweight':
        if (medicalCondition == 'None') {
          if (eatingSystem == 'DASH') {
            return 'nonegaindash';
          } else if (eatingSystem == 'Vegetarian') {
            return 'nonegainveget';
          } else if (eatingSystem == 'Mediterranean') {
            return 'nonegainmedi';
          }
        } else if (medicalCondition == 'Diabetes') {
          if (eatingSystem == 'Vegetarian') {
            return 'diabetesgainvege';
          } else if (eatingSystem == 'Mediterranean') {
            return 'diabetesgainmedi';
          }
        } else if (medicalCondition == 'Hypertension') {
          if (eatingSystem == 'DASH') {
            return 'hypertensiongaindash';
          }
        } else if (medicalCondition == 'Hypotension') {
          if (eatingSystem == 'Vegetarian') {
            return 'hypogain';
          }
        }
        break;
      case 'normal':
        if (medicalCondition == 'None') {
          if (eatingSystem == 'DASH') {
            return 'nonegaindash';
          } else if (eatingSystem == 'Vegetarian') {
            return 'nonegainveget';
          } else if (eatingSystem == 'Mediterranean') {
            return 'nonegainmedi';
          }
        } else if (medicalCondition == 'Diabetes') {
          if (eatingSystem == 'Vegetarian') {
            return 'diabetesgainvege';
          } else if (eatingSystem == 'Mediterranean') {
            return 'diabetesgainmedi';
          }
        } else if (medicalCondition == 'Hypertension') {
          if (eatingSystem == 'DASH') {
            return 'hypertensiongaindash';
          }
        } else if (medicalCondition == 'Hypotension') {
          if (eatingSystem == 'Vegetarian') {
            return 'hypogain';
          }
        }
        break;
      case 'overweight':
        if (medicalCondition == 'None') {
          if (eatingSystem == 'DASH') {
            return 'nonelosedash';
          } else if (eatingSystem == 'Vegetarian') {
            return 'noneloseveget';
          } else if (eatingSystem == 'Mediterranean') {
            return 'nonelosemedi';
          }
        } else if (medicalCondition == 'Diabetes') {
          if (eatingSystem == 'Vegetarian') {
            return 'diabetesloseveget';
          } else if (eatingSystem == 'Mediterranean') {
            return 'diabeteslosemedi';
          }
        } else if (medicalCondition == 'Hypertension') {
          if (eatingSystem == 'DASH') {
            return 'hypertensionlosedash';
          }
        } else if (medicalCondition == 'Hypotension') {
          if (eatingSystem == 'Vegetarian') {
            return 'hypolose';
          }
        }
        break;
      default:
        return ''; // Handle default case
    }

    return ''; // Default return if no match found
  }
}
