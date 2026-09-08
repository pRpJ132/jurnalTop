String getStatusText(int status) {
  switch (status) {
    case 0:
      return "Просрочено";
    case 1:
      return "Проверено";
    case 2:
      return "На проверке";
    case 3:
      return "Текущее";
    default:
      return "";
  }
}