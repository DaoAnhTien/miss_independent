import 'package:injectable/injectable.dart';
import 'package:miss_independent/common/api_client/data_state.dart';

import 'package:miss_independent/data/remote/member/member_service.dart';

import 'package:miss_independent/models/pagination.dart';
import 'package:miss_independent/models/user.dart';

abstract class MemberRepository {
  Future<DataState<Pagination<User>>> getMemberLatest(int page);
  Future<DataState<Pagination<User>>> getMemberOnline(int page);
  Future<DataState<Pagination<User>>> getMemberShip(int page, String memberType);
}
@LazySingleton(as: MemberRepository)
class MemberRepositoryImpl implements MemberRepository {
  final MemberService _memberService;

  MemberRepositoryImpl({required MemberService memberService})
      : _memberService = memberService;

  @override
  Future<DataState<Pagination<User>>> getMemberLatest(int page){
    return _memberService.getMemberLatest(page);
  }
  @override
  Future<DataState<Pagination<User>>> getMemberOnline(int page){
    return _memberService.getMemberOnline(page);
  }
  @override
  Future<DataState<Pagination<User>>> getMemberShip(int page, String memberType){
    return _memberService.getMemberShip(page,memberType);
  }
}

