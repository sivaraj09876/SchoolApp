
import 'package:flutter_bloc/flutter_bloc.dart';


class UserdataCubit extends Cubit<Map<String,dynamic>> {
  UserdataCubit() : super({});
 
  void setData(data){
  
    emit(data);
  }
  
}
