abstract class INotificationRepository {

  Future<Null> create(String idUser, String title, String subject);
}