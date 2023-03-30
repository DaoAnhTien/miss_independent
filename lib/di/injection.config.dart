// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i5;
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:miss_independent/common/api_client/api_client.dart' as _i9;
import 'package:miss_independent/configs/build_config.dart' as _i3;
import 'package:miss_independent/configs/currency_config.dart' as _i4;
import 'package:miss_independent/configs/language_config.dart' as _i6;
import 'package:miss_independent/data/local/datasource/auth_local_datasource.dart'
    as _i10;
import 'package:miss_independent/data/local/datasource/category_local_datasource.dart'
    as _i12;
import 'package:miss_independent/data/local/datasource/event_local_datasource.dart'
    as _i13;
import 'package:miss_independent/data/local/datasource/forum_local_datasource.dart'
    as _i15;
import 'package:miss_independent/data/local/datasource/home_posts_local_datasource.dart'
    as _i19;
import 'package:miss_independent/data/local/datasource/member_local_datasource.dart'
    as _i22;
import 'package:miss_independent/data/local/datasource/notifications_local_datasource.dart'
    as _i24;
import 'package:miss_independent/data/local/datasource/order_local_datasource.dart'
    as _i25;
import 'package:miss_independent/data/local/datasource/product_local_datasource.dart'
    as _i29;
import 'package:miss_independent/data/local/keychain/shared_prefs.dart' as _i8;
import 'package:miss_independent/data/remote/auth/auth_service.dart' as _i11;
import 'package:miss_independent/data/remote/events/event_service.dart' as _i14;
import 'package:miss_independent/data/remote/forum/forum_service.dart' as _i16;
import 'package:miss_independent/data/remote/friend/friend_service.dart'
    as _i18;
import 'package:miss_independent/data/remote/friend_request/friend_request_service.dart'
    as _i17;
import 'package:miss_independent/data/remote/member/member_service.dart'
    as _i21;
import 'package:miss_independent/data/remote/mi_services/mi_services_service.dart'
    as _i20;
import 'package:miss_independent/data/remote/notification/notification_service.dart'
    as _i23;
import 'package:miss_independent/data/remote/order/order_service.dart' as _i26;
import 'package:miss_independent/data/remote/post/post_service.dart' as _i28;
import 'package:miss_independent/data/remote/post_comments/post_comments_service.dart'
    as _i27;
import 'package:miss_independent/data/remote/product/product_service.dart'
    as _i30;
import 'package:miss_independent/data/remote/shop/shop_service.dart' as _i31;
import 'package:miss_independent/data/remote/user_profile/user_profile_service.dart'
    as _i32;
import 'package:miss_independent/di/modules.dart' as _i81;
import 'package:miss_independent/modules/auth/bloc/auth_cubit.dart' as _i62;
import 'package:miss_independent/modules/events/bloc/event_detail_cubit.dart'
    as _i67;
import 'package:miss_independent/modules/events/bloc/events_cubit.dart' as _i38;
import 'package:miss_independent/modules/friend_requests/bloc/friend_request_cubit.dart'
    as _i68;
import 'package:miss_independent/modules/friends/bloc/friends_cubit.dart'
    as _i42;
import 'package:miss_independent/modules/home/bloc/add_post_cubit.dart' as _i60;
import 'package:miss_independent/modules/home/bloc/home_posts_cubit.dart'
    as _i69;
import 'package:miss_independent/modules/members/bloc/member_cubit.dart'
    as _i71;
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_cubit.dart'
    as _i47;
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_all_posts_cubit.dart'
    as _i43;
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_cubit.dart'
    as _i48;
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_members_cubit.dart'
    as _i49;
import 'package:miss_independent/modules/mi_forum/bloc/mi_forum_detail_popular_posts_cubit.dart'
    as _i44;
import 'package:miss_independent/modules/my_profile/bloc/change_password_cubit.dart'
    as _i35;
import 'package:miss_independent/modules/my_profile/bloc/edit_profile_cubit.dart'
    as _i36;
import 'package:miss_independent/modules/notifications/bloc/notification_cubit.dart'
    as _i72;
import 'package:miss_independent/modules/order/bloc/checkout_cubit.dart'
    as _i64;
import 'package:miss_independent/modules/order/bloc/order_history_cubit.dart'
    as _i73;
import 'package:miss_independent/modules/order/bloc/order_management_cubit.dart'
    as _i74;
import 'package:miss_independent/modules/post_comments/bloc/report_comment_cubit.dart'
    as _i55;
import 'package:miss_independent/modules/services/bloc/mi_services_cubit.dart'
    as _i70;
import 'package:miss_independent/modules/shop/bloc/cart_cubit.dart' as _i63;
import 'package:miss_independent/modules/shop/bloc/category_cubit.dart' as _i34;
import 'package:miss_independent/modules/shop/bloc/product_detail_cubit.dart'
    as _i76;
import 'package:miss_independent/modules/shop/bloc/shop_cubit.dart' as _i77;
import 'package:miss_independent/modules/shop_management/bloc/add_product_cubit.dart'
    as _i61;
import 'package:miss_independent/modules/shop_management/bloc/shop_management_cubit.dart'
    as _i56;
import 'package:miss_independent/modules/user_detail/bloc/user_editorials_cubit.dart'
    as _i78;
import 'package:miss_independent/modules/user_detail/bloc/user_photos_cubit.dart'
    as _i79;
import 'package:miss_independent/modules/user_detail/bloc/user_profile_cubit.dart'
    as _i80;
import 'package:miss_independent/modules/user_detail/bloc/user_videos_cubit.dart'
    as _i59;
import 'package:miss_independent/repositories/auth_repository.dart' as _i33;
import 'package:miss_independent/repositories/checkout_repository.dart' as _i51;
import 'package:miss_independent/repositories/event_repository.dart' as _i37;
import 'package:miss_independent/repositories/forum_repository.dart' as _i39;
import 'package:miss_independent/repositories/friend_repository.dart' as _i40;
import 'package:miss_independent/repositories/friend_request_repository.dart'
    as _i41;
import 'package:miss_independent/repositories/member_repository.dart' as _i46;
import 'package:miss_independent/repositories/mi_services_repository.dart'
    as _i45;
import 'package:miss_independent/repositories/notification_repository.dart'
    as _i50;
import 'package:miss_independent/repositories/post_comments_repository.dart'
    as _i52;
import 'package:miss_independent/repositories/post_repository.dart' as _i53;
import 'package:miss_independent/repositories/product_repository.dart' as _i54;
import 'package:miss_independent/repositories/shop_repository.dart' as _i57;
import 'package:miss_independent/repositories/user_profile_repository.dart'
    as _i58;
import 'package:miss_independent/widgets/comments_list/bloc/comment_cubit.dart'
    as _i65;
import 'package:miss_independent/widgets/comments_list/bloc/comment_reply_cubit.dart'
    as _i66;
import 'package:miss_independent/widgets/comments_list/bloc/post_comments_cubit.dart'
    as _i75;
import 'package:shared_preferences/shared_preferences.dart' as _i7;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final injectableModule = _$InjectableModule();
    gh.lazySingleton<_i3.BuildConfig>(() => _i3.BuildConfig());
    gh.lazySingleton<_i4.CurrencyConfig>(() => _i4.CurrencyConfig());
    gh.lazySingleton<_i5.Dio>(() => injectableModule.dio);
    gh.lazySingleton<_i6.LanguageConfig>(() => _i6.LanguageConfig());
    await gh.factoryAsync<_i7.SharedPreferences>(
      () => injectableModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i8.SharedPrefs>(
        () => _i8.SharedPrefs(gh<_i7.SharedPreferences>()));
    gh.singleton<_i9.ApiClient>(_i9.ApiClient(dio: gh<_i5.Dio>()));
    gh.lazySingleton<_i10.AuthLocalDatasource>(
        () => _i10.AuthLocalDatasourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i11.AuthService>(
        () => _i11.AuthServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i12.CategoryLocalDatasource>(
        () => _i12.CategoryLocalDatasourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i13.EventLocalDatasource>(
        () => _i13.EventLocalDatasourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i14.EventService>(
        () => _i14.EventServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i15.ForumLocalDatasource>(
        () => _i15.ForumLocalDatasourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i16.ForumService>(
        () => _i16.ForumServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i17.FriendRequestService>(
        () => _i17.FriendRequestServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i18.FriendService>(
        () => _i18.FriendServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i19.HomePostsLocalDataSource>(
        () => _i19.HomePostsLocalDataSourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i20.MIServicesService>(
        () => _i20.MIServicesServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i21.MemberService>(
        () => _i21.MemberServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i22.MembersLocalDataSource>(
        () => _i22.MembersLocalDataSourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i23.NotificationService>(
        () => _i23.NotificationServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i24.NotificationsLocalDatasource>(
        () => _i24.NotificationsLocalDatasourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i25.OrderLocalDataSource>(
        () => _i25.OrderLocalDataSourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i26.OrderService>(
        () => _i26.OrderServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i27.PostCommentsService>(
        () => _i27.PostCommentsServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i28.PostService>(
        () => _i28.PostServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i29.ProductLocalDatasource>(
        () => _i29.ProductLocalDatasourceImpl(gh<_i8.SharedPrefs>()));
    gh.lazySingleton<_i30.ProductService>(
        () => _i30.ProductServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i31.ShopService>(
        () => _i31.ShopServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i32.UserProfileService>(
        () => _i32.UserProfileServiceImpl(gh<_i9.ApiClient>()));
    gh.lazySingleton<_i33.AuthRepository>(() => _i33.AuthRepositoryImpl(
          authService: gh<_i11.AuthService>(),
          authLocalDatasource: gh<_i10.AuthLocalDatasource>(),
        ));
    gh.factory<_i34.CategoryCubit>(() => _i34.CategoryCubit(
          authRepository: gh<_i33.AuthRepository>(),
          categoryLocalDatasource: gh<_i12.CategoryLocalDatasource>(),
        ));
    gh.factory<_i35.ChangePasswordCubit>(() =>
        _i35.ChangePasswordCubit(authRepository: gh<_i33.AuthRepository>()));
    gh.factory<_i36.EditProfileCubit>(
        () => _i36.EditProfileCubit(authRepository: gh<_i33.AuthRepository>()));
    gh.lazySingleton<_i37.EventRepository>(
        () => _i37.EventRepositoryImpl(eventService: gh<_i14.EventService>()));
    gh.factory<_i38.EventsCubit>(() => _i38.EventsCubit(
          eventRepository: gh<_i37.EventRepository>(),
          eventLocalDatasource: gh<_i13.EventLocalDatasource>(),
        ));
    gh.lazySingleton<_i39.ForumRepository>(
        () => _i39.ForumRepositoryImpl(forumService: gh<_i16.ForumService>()));
    gh.lazySingleton<_i40.FriendRepository>(() =>
        _i40.FriendRepositoryImpl(friendService: gh<_i18.FriendService>()));
    gh.lazySingleton<_i41.FriendRequestRepository>(() =>
        _i41.FriendRequestRepositoryImpl(
            friendRequestService: gh<_i17.FriendRequestService>()));
    gh.factory<_i42.FriendsCubit>(
        () => _i42.FriendsCubit(friendRepository: gh<_i40.FriendRepository>()));
    gh.factory<_i43.MIForumDetailAllPostsCubit>(() =>
        _i43.MIForumDetailAllPostsCubit(
            forumRepository: gh<_i39.ForumRepository>()));
    gh.factory<_i44.MIForumDetailPopularPostsCubit>(() =>
        _i44.MIForumDetailPopularPostsCubit(
            forumRepository: gh<_i39.ForumRepository>()));
    gh.lazySingleton<_i45.MIServicesRepository>(() =>
        _i45.MIServicesRepositoryImpl(
            miServicesService: gh<_i20.MIServicesService>()));
    gh.lazySingleton<_i46.MemberRepository>(() =>
        _i46.MemberRepositoryImpl(memberService: gh<_i21.MemberService>()));
    gh.factory<_i47.MiForumCubit>(() => _i47.MiForumCubit(
          forumRepository: gh<_i39.ForumRepository>(),
          forumLocalDatasource: gh<_i15.ForumLocalDatasource>(),
        ));
    gh.factory<_i48.MiForumDetailCubit>(() =>
        _i48.MiForumDetailCubit(forumRepository: gh<_i39.ForumRepository>()));
    gh.factory<_i49.MiForumDetailMembersCubit>(() =>
        _i49.MiForumDetailMembersCubit(
            forumRepository: gh<_i39.ForumRepository>()));
    gh.lazySingleton<_i50.NotificationRepository>(() =>
        _i50.NotificationRepositoryImpl(
            notificationService: gh<_i23.NotificationService>()));
    gh.lazySingleton<_i51.OrderRepository>(
        () => _i51.OrderRepositoryImpl(orderService: gh<_i26.OrderService>()));
    gh.lazySingleton<_i52.PostCommentsRepository>(() =>
        _i52.PostCommentsRepositoryImpl(
            postCommentsService: gh<_i27.PostCommentsService>()));
    gh.lazySingleton<_i53.PostRepository>(
        () => _i53.PostRepositoryImpl(postService: gh<_i28.PostService>()));
    gh.lazySingleton<_i54.ProductRepository>(() =>
        _i54.ProductRepositoryImpl(productService: gh<_i30.ProductService>()));
    gh.factory<_i55.ReportCommentCubit>(() => _i55.ReportCommentCubit(
        postCommentsRepository: gh<_i52.PostCommentsRepository>()));
    gh.factory<_i56.ShopManagementCubit>(() => _i56.ShopManagementCubit(
          productRepository: gh<_i54.ProductRepository>(),
          productLocalDatasource: gh<_i29.ProductLocalDatasource>(),
        ));
    gh.lazySingleton<_i57.ShopRepository>(
        () => _i57.ShopRepositoryImpl(shopService: gh<_i31.ShopService>()));
    gh.lazySingleton<_i58.UserProfileRepository>(() =>
        _i58.UserProfileRepositoryImpl(
            userProfileService: gh<_i32.UserProfileService>()));
    gh.factory<_i59.UserVideosCubit>(() => _i59.UserVideosCubit(
        userProfileRepository: gh<_i58.UserProfileRepository>()));
    gh.factory<_i60.AddPostCubit>(
        () => _i60.AddPostCubit(postRepository: gh<_i53.PostRepository>()));
    gh.factory<_i61.AddProductCubit>(() => _i61.AddProductCubit(
          productRepository: gh<_i54.ProductRepository>(),
          authRepository: gh<_i33.AuthRepository>(),
        ));
    gh.singleton<_i62.AuthCubit>(_i62.AuthCubit(
      authRepository: gh<_i33.AuthRepository>(),
      authLocalDatasource: gh<_i10.AuthLocalDatasource>(),
    ));
    gh.factory<_i63.CartCubit>(
        () => _i63.CartCubit(shopRepository: gh<_i57.ShopRepository>()));
    gh.factory<_i64.CheckoutCubit>(() => _i64.CheckoutCubit(
          orderRepository: gh<_i51.OrderRepository>(),
          orderLocalDataSource: gh<_i25.OrderLocalDataSource>(),
        ));
    gh.factory<_i65.CommentCubit>(() => _i65.CommentCubit(
        postCommentsRepository: gh<_i52.PostCommentsRepository>()));
    gh.factory<_i66.CommentReplyCubit>(() => _i66.CommentReplyCubit(
        postCommentsRepository: gh<_i52.PostCommentsRepository>()));
    gh.factory<_i67.EventDetailCubit>(() =>
        _i67.EventDetailCubit(eventRepository: gh<_i37.EventRepository>()));
    gh.factory<_i68.FriendRequestCubit>(() => _i68.FriendRequestCubit(
        friendRequestRepository: gh<_i41.FriendRequestRepository>()));
    gh.factory<_i69.HomePostsCubit>(() => _i69.HomePostsCubit(
          postRepository: gh<_i53.PostRepository>(),
          homePostsLocalDataSource: gh<_i19.HomePostsLocalDataSource>(),
          authRepository: gh<_i33.AuthRepository>(),
          categoryLocalDatasource: gh<_i12.CategoryLocalDatasource>(),
        ));
    gh.factory<_i70.MIServicesCubit>(() => _i70.MIServicesCubit(
          authRepository: gh<_i33.AuthRepository>(),
          miServicesRepository: gh<_i45.MIServicesRepository>(),
        ));
    gh.factory<_i71.MemberCubit>(() => _i71.MemberCubit(
          memberRepository: gh<_i46.MemberRepository>(),
          membersLocalDataSource: gh<_i22.MembersLocalDataSource>(),
        ));
    gh.factory<_i72.NotificationCubit>(() => _i72.NotificationCubit(
          notificationRepository: gh<_i50.NotificationRepository>(),
          notificationsLocalDatasource: gh<_i24.NotificationsLocalDatasource>(),
        ));
    gh.factory<_i73.OrderHistoryCubit>(() => _i73.OrderHistoryCubit(
          checkoutRepository: gh<_i51.OrderRepository>(),
          orderLocalDataSource: gh<_i25.OrderLocalDataSource>(),
        ));
    gh.factory<_i74.OrderManagementCubit>(() => _i74.OrderManagementCubit(
          checkoutRepository: gh<_i51.OrderRepository>(),
          orderLocalDataSource: gh<_i25.OrderLocalDataSource>(),
        ));
    gh.factory<_i75.PostCommentsCubit>(() => _i75.PostCommentsCubit(
        postCommentsRepository: gh<_i52.PostCommentsRepository>()));
    gh.factory<_i76.ProductDetailCubit>(() =>
        _i76.ProductDetailCubit(shopRepository: gh<_i57.ShopRepository>()));
    gh.factory<_i77.ShopCubit>(
        () => _i77.ShopCubit(shopRepository: gh<_i57.ShopRepository>()));
    gh.factory<_i78.UserEditorialsCubit>(() => _i78.UserEditorialsCubit(
          userProfileRepository: gh<_i58.UserProfileRepository>(),
          postRepository: gh<_i53.PostRepository>(),
        ));
    gh.factory<_i79.UserPhotosCubit>(() => _i79.UserPhotosCubit(
        userProfileRepository: gh<_i58.UserProfileRepository>()));
    gh.factory<_i80.UserProfileCubit>(() => _i80.UserProfileCubit(
        userProfileRepository: gh<_i58.UserProfileRepository>()));
    return this;
  }
}

class _$InjectableModule extends _i81.InjectableModule {}
