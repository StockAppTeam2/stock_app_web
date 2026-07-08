import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// Home page heading text
  ///
  /// In en, this message translates to:
  /// **'HOME PAGE'**
  String get homePage;

  /// Home page heading text
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePageDrawer;

  ///  Opening stock text - Home page
  ///
  /// In en, this message translates to:
  /// **'OPENING STOCK'**
  String get openingStock;

  ///  Receipt stock text - Home page
  ///
  /// In en, this message translates to:
  /// **'RECEIPT'**
  String get receipt;

  ///  closing stock text - Home page
  ///
  /// In en, this message translates to:
  /// **'CLOSING STOCK'**
  String get closingStock;

  ///  sales  text - Home page
  ///
  /// In en, this message translates to:
  /// **'SALES'**
  String get sales;

  ///  reports  text - Home page
  ///
  /// In en, this message translates to:
  /// **'REPORTS'**
  String get reports;

  ///  pos  text - Home page
  ///
  /// In en, this message translates to:
  /// **'POS ENTRY'**
  String get posEntry;

  /// view
  ///  Opening + Receipt - opening page
  ///
  /// In en, this message translates to:
  /// **'view \n OB + Receipt'**
  String get viewOpeningPurchase;

  /// Opening Stock (Receipt not included) - opening page
  ///
  /// In en, this message translates to:
  /// **'Opening Stock (Receipt not included)'**
  String get purchaseNotIncluded;

  /// Language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Check Reminder
  ///
  /// In en, this message translates to:
  /// **'Check Reminder'**
  String get checkReminder;

  /// set reminder
  ///
  /// In en, this message translates to:
  /// **'Set Reminder'**
  String get setReminder;

  /// Settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Access Date
  ///
  /// In en, this message translates to:
  /// **'View Date'**
  String get accessDate;

  /// Masters
  ///
  /// In en, this message translates to:
  /// **'Masters'**
  String get masters;

  /// shop
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// shopName
  ///
  /// In en, this message translates to:
  /// **'shop Name'**
  String get shopName;

  /// shopDetails
  ///
  /// In en, this message translates to:
  /// **'shop Details'**
  String get shopDetails;

  /// staff
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// brand
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// category
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// group
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// size
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get size;

  /// range
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get range;

  /// backup
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// download
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get download;

  /// add shop
  ///
  /// In en, this message translates to:
  /// **'add Shop'**
  String get addShop;

  /// shop id
  ///
  /// In en, this message translates to:
  /// **'Shop Id'**
  String get shopId;

  /// address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// street
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// city
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// district
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// zip code
  ///
  /// In en, this message translates to:
  /// **'Zip Code'**
  String get zipCode;

  /// submit
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// enter sales man name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get salesManName;

  /// enter mobile number
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// add in sales man input page
  ///
  /// In en, this message translates to:
  /// **'ADD'**
  String get add;

  /// add new brand
  ///
  /// In en, this message translates to:
  /// **'New Brand'**
  String get newBrand;

  /// filter text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// add group button
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get addGroup;

  /// add new group
  ///
  /// In en, this message translates to:
  /// **'Add New Group'**
  String get addNewGroup;

  /// Add Category
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// addNewCategory
  ///
  /// In en, this message translates to:
  /// **'Add New Category'**
  String get addNewCategory;

  /// add size
  ///
  /// In en, this message translates to:
  /// **'Add Size'**
  String get addSize;

  /// add new size in ml
  ///
  /// In en, this message translates to:
  /// **'Add Size In ml'**
  String get addSizeInMl;

  /// add range
  ///
  /// In en, this message translates to:
  /// **'Add Range'**
  String get addRange;

  /// add new range
  ///
  /// In en, this message translates to:
  /// **'Add Range'**
  String get addNewRange;

  /// user Access
  ///
  /// In en, this message translates to:
  /// **'User Access'**
  String get userAccess;

  /// txt
  ///
  /// In en, this message translates to:
  /// **'Updated On'**
  String get updatedOn;

  /// apply filter in brand filter page
  ///
  /// In en, this message translates to:
  /// **'Apply Filter'**
  String get applyFilter;

  ///  Purchase in Purchase page
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// add Purchase in Purchase page
  ///
  /// In en, this message translates to:
  /// **'Add Purchase'**
  String get addPurchase;

  /// add new purchase
  ///
  /// In en, this message translates to:
  /// **'Add New Purchase'**
  String get addNewPurchase;

  ///  select the product
  ///
  /// In en, this message translates to:
  /// **'Search The Product Above'**
  String get searchTheProductAbove;

  /// error message
  ///
  /// In en, this message translates to:
  /// **'Case Can\'t Be Empty'**
  String get caseCannotBeEmpty;

  /// enter case
  ///
  /// In en, this message translates to:
  /// **'Enter Case'**
  String get enterCase;

  /// error message
  ///
  /// In en, this message translates to:
  /// **'Bottles Can\'t Be Empty'**
  String get bottleCannotBeEmpty;

  /// enter bottle
  ///
  /// In en, this message translates to:
  /// **'Enter Bottles'**
  String get enterBottles;

  /// error message
  ///
  /// In en, this message translates to:
  /// **'Some Values Are Wrong'**
  String get someValuesAreWrong;

  /// message
  ///
  /// In en, this message translates to:
  /// **'Already Entered'**
  String get alreadyEntered;

  /// text field hint
  ///
  /// In en, this message translates to:
  /// **'Enter Invoice No'**
  String get enterInvoiceNo;

  /// text for select an item
  ///
  /// In en, this message translates to:
  /// **'Select A Item'**
  String get selectAItem;

  /// save text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// message for the brand state
  ///
  /// In en, this message translates to:
  /// **'Active & Inactive Brand'**
  String get activeAndInactiveBrand;

  /// check Internet
  ///
  /// In en, this message translates to:
  /// **'Check Internet Connection'**
  String get checkInternetConnection;

  /// invoice Value
  ///
  /// In en, this message translates to:
  /// **'Invoice Value'**
  String get invoiceValue;

  /// message text
  ///
  /// In en, this message translates to:
  /// **'Do You Want To Delete ?'**
  String get doYouWantToDelete;

  /// negative error
  ///
  /// In en, this message translates to:
  /// **'Current Inventory Should Not Be Negative'**
  String get currentInventoryShouldNotBeNegative;

  /// internet error
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get noInternetConnection;

  /// search text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// case one
  ///
  /// In en, this message translates to:
  /// **'Case: '**
  String get case1;

  /// bottle
  ///
  /// In en, this message translates to:
  /// **'Bottle: '**
  String get bottle;

  /// total Bottle
  ///
  /// In en, this message translates to:
  /// **'Tot Bottles: '**
  String get totBottle;

  /// Rs text
  ///
  /// In en, this message translates to:
  /// **'Rs.'**
  String get rs;

  /// error msg
  ///
  /// In en, this message translates to:
  /// **'No Details Found'**
  String get noDataFound;

  /// last item
  ///
  /// In en, this message translates to:
  /// **'Last Item'**
  String get lastItem;

  /// No description provided for @firstItem.
  ///
  /// In en, this message translates to:
  /// **'First Item'**
  String get firstItem;

  /// closing overWrite firebase message
  ///
  /// In en, this message translates to:
  /// **'Already Entered Do You Want To Update ?'**
  String get alreadyEnteredDoYouWantToUpdate;

  /// product
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// Select item
  ///
  /// In en, this message translates to:
  /// **'Select Item'**
  String get selectItem;

  /// back btn txt
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// btn txt
  ///
  /// In en, this message translates to:
  /// **'Save & Next'**
  String get saveAndNext;

  /// txt for product id , price, number input fields
  ///
  /// In en, this message translates to:
  /// **'Enter Valid Number'**
  String get enterValidNumber;

  /// check the date
  ///
  /// In en, this message translates to:
  /// **'Please Verify That You Are Updating Correct Date'**
  String get pleaseVerifyThatYouAreUpdatingCorrectDate;

  /// Update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @pdfDownloadFailed.
  ///
  /// In en, this message translates to:
  /// **'Pdf Download Failed'**
  String get pdfDownloadFailed;

  /// session lock
  ///
  /// In en, this message translates to:
  /// **'Final Submission'**
  String get finalSubmission;

  /// note in report page
  ///
  /// In en, this message translates to:
  /// **'To view the latest updated report, please connect to the internet.'**
  String get reportNotes;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// detail
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// sms
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get sms;

  /// graph
  ///
  /// In en, this message translates to:
  /// **'Graph'**
  String get graph;

  /// txt
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// txt
  ///
  /// In en, this message translates to:
  /// **'Previous Day'**
  String get previousDay;

  /// txt
  ///
  /// In en, this message translates to:
  /// **'Cumulative'**
  String get cumulative;

  /// txt
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @dataBackUpLocated.
  ///
  /// In en, this message translates to:
  /// **'Data Backup Located'**
  String get dataBackUpLocated;

  /// txt
  ///
  /// In en, this message translates to:
  /// **'Before entering new data, please ensure you download the cloud data.'**
  String get dataBackupTxt;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Data Already Exist'**
  String get dataAlreadyExist;

  /// txt
  ///
  /// In en, this message translates to:
  /// **'Already Exist'**
  String get alreadyExist;

  /// description
  ///
  /// In en, this message translates to:
  /// **'New POS'**
  String get newPos;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Edit POS'**
  String get editPos;

  /// description
  ///
  /// In en, this message translates to:
  /// **'POS Details'**
  String get posDetails;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Previous Days Cumulative'**
  String get previousDaysCumulative;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// description
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// description
  ///
  /// In en, this message translates to:
  /// **'The user is allowed to disable the item when there is no stock available.'**
  String get disableBrandTxt;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Id Can\'t'**
  String get idCannotBeEmpty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Id'**
  String get enterId;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Brand Can\'t Be Empty'**
  String get brandCannotBeEmpty;

  /// No description provided for @effectiveFrom.
  ///
  /// In en, this message translates to:
  /// **'Effective From'**
  String get effectiveFrom;

  /// No description provided for @selectAnItem.
  ///
  /// In en, this message translates to:
  /// **'Select an Item'**
  String get selectAnItem;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Select All The Fields'**
  String get selectAllTheFields;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter A Number'**
  String get enterANumber;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Item Added Successfully'**
  String get itemAddedSuccessfully;

  /// description
  ///
  /// In en, this message translates to:
  /// **'New Product'**
  String get newProduct;

  /// description
  ///
  /// In en, this message translates to:
  /// **'product ID'**
  String get productId;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Product ID'**
  String get enterProductId;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Brand'**
  String get enterBrand;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter How Many Bottles Per Case'**
  String get enterHowManyBottlePerCase;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Product Id Already Exist'**
  String get productIdAlreadyExist;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// description
  ///
  /// In en, this message translates to:
  /// **'S.No'**
  String get sno;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Brand Name'**
  String get enterBrandName;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Do You Want To Continue ?'**
  String get doYouWantToContinue;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Waiting For Backup...'**
  String get waitingForBackup;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get backupInProgress;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Backup Successful'**
  String get backupSuccessFul;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Waiting For Download...'**
  String get waitingForDownload;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get downloadInProgress;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Downloaded Successful'**
  String get downloadedSuccessful;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Refreshing in Progress Do you Want to Cancel'**
  String get cancelDownload;

  /// description
  ///
  /// In en, this message translates to:
  /// **'My Reminders'**
  String get myReminders;

  /// description
  ///
  /// In en, this message translates to:
  /// **'No Reminder Notes'**
  String get noReminderNote;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Today Date'**
  String get todayDate;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Access Date'**
  String get accessDates;

  /// description
  ///
  /// In en, this message translates to:
  /// **'App View Date'**
  String get appAccessDate;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Reminder Note'**
  String get enterReminderNote;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Reminder here...'**
  String get enterReminderHere;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Attendance Report'**
  String get attendanceReport;

  /// description
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// description
  ///
  /// In en, this message translates to:
  /// **'TO'**
  String get to;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Sales Man'**
  String get salesMan;

  /// description
  ///
  /// In en, this message translates to:
  /// **'In Charge'**
  String get inCharge;

  /// description
  ///
  /// In en, this message translates to:
  /// **'OP Stock : Rs '**
  String get opStockRs;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Purchase : Rs '**
  String get purchaseRs;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Actual Stock : Rs '**
  String get actualStockRs;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Closing Stock : Rs '**
  String get closingStockRs;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Sales : Rs '**
  String get salesRs;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Consolidate Report'**
  String get consolidateReport;

  /// description
  ///
  /// In en, this message translates to:
  /// **'OP Btls Qty : '**
  String get opBottlesQty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Purchase Btls Qty : '**
  String get purchaseBottlesQty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Actual Btls Qty : '**
  String get actualBottlesQty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Closing Btls Qty : '**
  String get closingBottlesQty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Sales Btls Qty : '**
  String get salesBottlesQty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Bottles Qty'**
  String get bottleQty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Total Price'**
  String get totalPrice;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Detailed Report'**
  String get detailedReport;

  /// manual
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get manual;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Price'**
  String get enterPrice;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Value : Rs'**
  String get valueRs;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Pos Date'**
  String get posDate;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Add Pos'**
  String get addPos;

  /// description
  ///
  /// In en, this message translates to:
  /// **'OB'**
  String get ob;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Inv No:'**
  String get invNo;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Invoice Value :\n Rs.'**
  String get invoiceValueRs;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Purchase Invoice'**
  String get purchaseInvoice;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get updated;

  /// description
  ///
  /// In en, this message translates to:
  /// **'\nSuccessfully'**
  String get successfully;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Invalid Input'**
  String get invalidInput;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Please Provide Valid  Value'**
  String get pleaseProvideValidValue;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Edit Inward'**
  String get editInward;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Invoice date'**
  String get invoiceDate;

  /// description
  ///
  /// In en, this message translates to:
  /// **'SELECT DATE'**
  String get selectDate;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Please Check Your Internet Connection and Try Again'**
  String get pleaseCheckYourInternetConnectionTryAgain;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Profile Updated Successfully.'**
  String get profileUpdatedSuccessfully;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Final Submission'**
  String get informToSupervisor;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Add Sales Man'**
  String get addSalesMan;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Sales Man Name'**
  String get enterSalesManName;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterMobileNumber;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Mobile number must be 10 characters long'**
  String get mobileNumberTenCharacter;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Temporary User'**
  String get temporaryUser;

  /// description
  ///
  /// In en, this message translates to:
  /// **'This user is only available temporary.'**
  String get thisUserOnlyAvailableTemporary;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Sales Man Added Successfully'**
  String get salesManAddedSuccessfully;

  /// description
  ///
  /// In en, this message translates to:
  /// **'My Sales Man'**
  String get mySalesMan;

  /// description
  ///
  /// In en, this message translates to:
  /// **'No Sales Man Found'**
  String get noSalesManFound;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Are you sure do you want to delete this {phoneNumber} sales man?'**
  String deletePhoneNumber(String phoneNumber);

  /// description
  ///
  /// In en, this message translates to:
  /// **'MRP'**
  String get mrp;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Today CB Entry Person'**
  String get attendance;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Attendance List'**
  String get attendanceList;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Entry By'**
  String get entryBy;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Data Submitted Successfully'**
  String get dataSubmittedSuccessfully;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Sit and Relax...\nWe are preparing your Sales Report,\nIt Will Take a Few Seconds...'**
  String get itWillTakeFewSeconds;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Bottle Per Case'**
  String get bottlePerCase;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Add Filter'**
  String get addFilter;

  /// description
  ///
  /// In en, this message translates to:
  /// **'No Data'**
  String get noData;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Consider my Last Day Closing Stock is Selected Date opening Stock'**
  String get lastClosingTodayOpening;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// description
  ///
  /// In en, this message translates to:
  /// **'The Database is Empty'**
  String get theDatabaseIsEmpty;

  /// description
  ///
  /// In en, this message translates to:
  /// **'You Are Up to Date'**
  String get youAreUpToDate;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Report Submitted Successfully'**
  String get todaySessionClosed;

  /// No description provided for @valueShouldNotBeNegative.
  ///
  /// In en, this message translates to:
  /// **'Value Should Not Be Negative ?'**
  String get valueShouldNotBeNegative;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Already Updated'**
  String get alreadyUpdated;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Do you want to Update again?'**
  String get replaceExistingFile;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Below Items Not Filled'**
  String get belowItemsNotFilled;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Lock Today Session'**
  String get lockTodaySession;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Entry Completed.\nReport Will Submitted to Supervisor.'**
  String get pressYesToLockTodaySession;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Today Session is Open'**
  String get todaySessionIsOpen;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Report Submitted'**
  String get todaySessionIsClosed;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get unlock;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong Please Try Again'**
  String get somethingWentWrongPleaseTryAgain;

  /// description
  ///
  /// In en, this message translates to:
  /// **'Please Note'**
  String get pleaseNote;

  /// description
  ///
  /// In en, this message translates to:
  /// **'No Brand Data Available'**
  String get noBrandDataAvailable;

  /// No description provided for @belowItemNotFilledBundleRetailIsZeroPressYes.
  ///
  /// In en, this message translates to:
  /// **'Below Items Not Filled ?\nBundle & Retail is 0 Press \'Yes\''**
  String get belowItemNotFilledBundleRetailIsZeroPressYes;

  /// pdf
  ///
  /// In en, this message translates to:
  /// **'PDF'**
  String get pdf;

  /// view
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// start
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// cb
  ///
  /// In en, this message translates to:
  /// **'CB'**
  String get cb;

  /// refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// resetPassword
  ///
  /// In en, this message translates to:
  /// **'Reset\nPassword'**
  String get resetPassword;

  /// total
  ///
  /// In en, this message translates to:
  /// **'TOTAL'**
  String get total;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
