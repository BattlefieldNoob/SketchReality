
class RunConfig{

  static final RunConfig instance=RunConfig._private();

  RunConfig._private();

  bool isOnline=true;

  bool unityActive=true;

  factory RunConfig()=>instance;

}

final currentConfig = RunConfig();