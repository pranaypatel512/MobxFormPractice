import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';
part 'form_store.g.dart';

class FormStore = _FormStore with _$FormStore;

abstract class _FormStore with Store{
  late List<ReactionDisposer> _disposers;
  final FormErrorState error = FormErrorState();
  @observable
  String name='';

  @observable
  String email='';

  @observable
  String password='';

  @action
  void setUserName(String value){
    name = value;
  }

  @action
  void setEmail(String value){
    email = value;
  }

  @action
  void setPassword(String value){
    password = value;
  }

  @computed
  bool get isUserCheckPending => _usernameCheck.status == FutureStatus.pending;

  @computed
  bool get canLogin => !error.hasErrors;

  @observable
  ObservableFuture<bool> _usernameCheck = ObservableFuture.value(false);

  @action
  Future validateUserName(String userName) async {
    if(isNull(userName) || userName.isEmpty){
      error.username = 'Cannot be blank';
      return;
    }
    try{
      _usernameCheck = ObservableFuture(checkValidUsername(userName));
      error.username = null;
      final isValid = await _usernameCheck;
      if(!isValid){
        error.username = 'Username cannot be "admin"';
        return;
      }
    }on Object catch (_) {
      error.username = null;
    }
    error.username = null;
  }

  Future<bool> checkValidUsername(String value) async{
    await Future.delayed(const Duration(seconds: 1));

    return value!='admin';
  }

  @action
  void validatePassword(String password){
    error.password = isNull(password) || password.isEmpty ? 'Cannot be blank' : null ;
  }

  @action
  void validateEmail(String email){
    error.email = isEmail(email) ? null : 'Cannot be blank';
  }

  void setUpValidators(){
    _disposers = [
      reaction((_) => name,validateUserName),
      reaction((_) => email,validateEmail),
      reaction((_) => password,validatePassword)

    ];
  }

  void dispose(){
    for(final d in _disposers){
      d();
    }
  }

  void validateAll(){
    validateEmail(name);
    validateEmail(password);
    validateEmail(email);
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String? username;

  @observable
  String? email;

  @observable
  String? password;

  @computed
  bool get hasErrors => username != null || email != null || password != null;
}
