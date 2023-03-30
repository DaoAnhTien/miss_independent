import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:miss_independent/common/constants/routes.dart';
import 'package:miss_independent/common/event/event_bus_mixin.dart';
import 'package:miss_independent/common/utils/navigator_utils.dart';
import 'package:miss_independent/models/user.dart';
import 'package:miss_independent/modules/auth/screens/create_profile_screen.dart';
import 'package:miss_independent/modules/auth/screens/forgot_password_screen.dart';
import 'package:miss_independent/modules/auth/screens/signup_screen.dart';
import 'package:miss_independent/modules/auth/screens/verify_email_screen.dart';
import 'package:miss_independent/modules/common/screens/webview_screen.dart';
import 'package:miss_independent/modules/events/screens/event_detail_screen.dart';
import 'package:miss_independent/modules/events/screens/events_screen.dart';
import 'package:miss_independent/modules/friends/bloc/friends_cubit.dart';
import 'package:miss_independent/modules/friends/screens/friends_screen.dart';
import 'package:miss_independent/modules/members/screens/members_screen.dart';
import 'package:miss_independent/modules/mi_forum/screens/mi_forum_detail_screen.dart';
import 'package:miss_independent/modules/mi_forum/screens/mi_forum_screen.dart';
import 'package:miss_independent/modules/my_profile/screens/change_password_screen.dart';
import 'package:miss_independent/modules/my_profile/screens/update_profile_screen.dart';
import 'package:miss_independent/modules/notifications/screens/notifications_screen.dart';
import 'package:miss_independent/modules/post_comments/screens/post_comments_screen.dart';
import 'package:miss_independent/modules/post_comments/screens/report_comment_screen.dart';
import 'package:miss_independent/modules/services/screens/mi_services_screen.dart';
import 'package:miss_independent/modules/order/screen/check_out_screen.dart';
import 'package:miss_independent/modules/shop/bloc/cart_cubit.dart';
import 'package:miss_independent/modules/shop/screens/category_screen.dart';
import 'package:miss_independent/modules/shop/screens/product_detail_screen.dart';
import 'package:miss_independent/modules/shop_management/screens/add_product_screen.dart';
import 'package:miss_independent/modules/shop/screens/cart_screen.dart';
import 'package:miss_independent/modules/shop_management/screens/shop_management_screen.dart';
import 'package:miss_independent/modules/tabbar/index.dart';
import 'package:miss_independent/modules/user_detail/screens/user_profile_screen.dart';

import '../common/theme/index.dart';
import '../di/injection.dart';
import '../generated/l10n.dart';
import '../modules/auth/screens/login_screen.dart';
import 'auth/bloc/auth_cubit.dart';
import 'order/screen/order_history_screen.dart';
import 'common/screens/sync_screen.dart';
import 'friend_requests/screens/friend_requests_screen.dart';
import 'home/screens/add_post_screen.dart';
import 'home/screens/edit_post_screen.dart';
import 'home/screens/report_post_screen.dart';
import 'my_profile/screens/my_profile_settings_screen.dart';
import 'order/screen/order_management_screen.dart';
import 'services/screens/mi_service_detail_screen.dart';
import 'shop/screens/shops_screen.dart';

class App extends StatefulWidget with EventBusMixin {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          lazy: false,
          create: (_) => getIt<AuthCubit>()..init(),
        ),
        BlocProvider<FriendsCubit>(
          create: (_) => getIt<FriendsCubit>(),
        ),
        BlocProvider<CartCubit>(
          create: (_) => getIt<CartCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale("en"),
        localizationsDelegates: const [
          S.delegate,
          CountryLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        themeMode: ThemeMode.light,
        theme: ThemeApp.lightTheme,
        darkTheme: ThemeApp.darkTheme,
        initialRoute: kSyncRoute,
        navigatorKey: NavigatorUtils.instance.navigatorKey,
        routes: {
          kSyncRoute: (context) => const SyncScreen(),
          kLoginRoute: (context) => const LoginScreen(),
          kSignUpRoute: (context) => const SignUpScreen(),
          kVerifyEmailRoute: (context) => const VerifyEmailScreen(),
          kForgotPasswordRoute: (context) => const ForgotPasswordScreen(),
          kCreateProfileRoute: (context) => const CreateProfileScreen(),
          kMainRoute: (context) => const MainTabBar(),
          kMIForumRoute: (context) => const MiForumScreen(),
          kFriendsRouter: (context) => const FriendsScreen(),
          kAddPostRouter: (context) => const AddPostScreen(),
          kEditPostRouter: (context) => const EditPostScreen(),
          kReportPostRoute: (context) => const ReportPostScreen(),
          kNotificationsRouter: (context) => const NotificationScreen(),
          kMembersRouter: (context) => const MembersScreen(),
          kUserProfileRouter: (context) => const UserProfileScreen(),
          kShopRouter: (context) => const ShopsScreen(),
          kCartRoute: (context) => const CartScreen(),
          kOrderHistoryRoute: (context) => const OrderHistoryScreen(),
          kOrderManagementRoute: (context) => const OrderManagementScreen(),
          kProductDetailRoute: (context) => const ProductDetailScreen(),
          kPostCommentsRoute: (context) => const PostCommentsScreen(),
          kReportCommentRoute: (context) => const ReportCommentScreen(),
          kMIForumDetailRoute: (context) => const MIForumDetailScreen(),
          kFriendRequestRoute: (context) => const FriendRequests(),
          kWebViewRoute: (context) => const WebViewScreen(),
          kCoachesMentorsServicesRoute: (context) =>
              const MIServicesScreen(type: ServiceProviderType.coachMentor),
          kConsultantsTrainersServicesRoute: (context) =>
              const MIServicesScreen(
                  type: ServiceProviderType.consultantTrainer),
          kCheckOutRoute: (context) => const CheckOutScreen(),
          kMyProfileRoute: (context) => const UserProfileScreen(),
          kChangePasswordRoute: (context) => const ChangePasswordScreen(),
          kEventsRoute: (context) => const EventsScreen(),
          kEventDetailRoute: (context) => const EventDetailScreen(),
          kSettingsRoute: (context) => const SettingsScreen(),
          kEditProfileRoute: (context) => const EditProfileScreen(),
          kCoachesMentorsDetailRoute: (context) => const MIServiceDetailScreen(
              type: ServiceProviderType.coachMentor),
          kConsultantsTrainersDetailRoute: (context) =>
              const MIServiceDetailScreen(
                  type: ServiceProviderType.consultantTrainer),
          kShopManagementRoute: (context) => const ShopManagementScreen(),
          kAddShopRoute: (context) => const AddProductScreen(),
          kCategoryRoute: (context) => const CategoryScreen(),
        },
      ),
    );
  }
}
