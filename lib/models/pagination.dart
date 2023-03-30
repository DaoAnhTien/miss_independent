import '../common/constants/services.dart';

enum DataSourceStatus {
  initial,
  loading,
  refreshing,
  empty,
  success,
  failed,
  loadMore
}

class Pagination<T> {
  Pagination({
    this.data,
    this.isEnd = true,
  });

  List<T>? data;
  bool isEnd;
  int currentPage = kDefaultFirstPageApi;
  int nextPage = kDefaultFirstPageApi + 1;

  void update(Pagination<T>? pagination) {
    addAll(pagination?.data ?? <T>[]);
    isEnd = pagination?.isEnd ?? true;
    if (!isEnd) {
      currentPage++;
      nextPage = currentPage;
    } else {
      increasePage();
    }
  }

  void addAll(List<T> values) {
    data?.addAll(values);
  }

  void add(T value) {
    data?.add(value);
  }

  void increasePage() {
    currentPage++;
    nextPage++;
  }

  void decreasePage() {
    if (currentPage > kDefaultFirstPageApi) {
      currentPage--;
      nextPage--;
    }
  }

  void reset() {
    data = [];
    isEnd = true;
    currentPage = kDefaultFirstPageApi;
    nextPage = currentPage + 1;
  }

  bool allowMore(DataSourceStatus? status) {
    return !isEnd &&
        status != DataSourceStatus.loadMore &&
        status != DataSourceStatus.refreshing;
  }
}
