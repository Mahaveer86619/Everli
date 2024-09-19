abstract class UseCase<Type, Params> {
  Future<Type> execute({required Params params});
}