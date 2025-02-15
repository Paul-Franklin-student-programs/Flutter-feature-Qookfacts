
class Response<T>{
  Status status = Status.LOADING;
  T data = T as T;
  String message = '';

  Response.loading(this.message) : status = Status.LOADING;
  Response.completed(this.data) : status = Status.COMPLETED;
  Response.error(this.message) : status = Status.ERROR;


  @override
    String toString() {
     return 'Status : $status \n Message : $message \n Data : $data';
    }
  }
  
  enum Status{
    LOADING,
    COMPLETED,
    ERROR
  }