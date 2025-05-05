import 'package:aurelius/core/failure.dart';
import 'package:fpdart/fpdart.dart';

typedef EitherUser<T> = Future<Either<Failure, T>>;
