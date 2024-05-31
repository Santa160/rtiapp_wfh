int getSerialNumber({required int page, required int index}) {
  int limit = 10;
  return (page - 1) * limit + index + 1;
}