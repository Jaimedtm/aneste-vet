enum AnimalChooser { perro, gato }
enum GenderChose { macho, hembra }

abstract class Animal {
  int age;
  double weight;
  String name;
  GenderChose gender;

  Animal({this.name, this.age = 10, this.weight, this.gender});
}

class Cat extends Animal {
  Cat({String name, int age, double weight, GenderChose gender})
      : super(name: name, age: age, weight: weight, gender: gender);
  @override
  String toString() {
    return 'Mi nombre es $name, tengo $age años, peso ${weight}Kg y soy un gato ${gender == GenderChose.macho ? 'macho' : 'hembra'}';
  }
}

class Dog extends Animal {
  Dog({String name, int age, double weight, GenderChose gender})
      : super(name: name, age: age, weight: weight, gender: gender);
  @override
  String toString() {
    return 'Mi nombre es $name, tengo $age años, peso ${weight}Kg y soy un perro ${gender == GenderChose.macho ? 'macho' : 'hembra'}';
  }
}
