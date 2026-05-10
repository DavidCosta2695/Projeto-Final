import '../modelos/cliente.dart';
import '../modelos/propriedade.dart';

final List<Cliente> clientes = [
  Cliente(name: 'André Brito', desiredType: 'T2', maxBudget: 250000),
  Cliente(name: 'David Costa', desiredType: 'T3', maxBudget: 400000),
  Cliente(name: 'Carlos Oliveira', desiredType: 'T1', maxBudget: 180000),
];

final List<Propriedade> propriedades = [
  Propriedade(
    title: 'Apartamento Moderno',
    type: 'T2',
    price: 230000,
    location: 'Lisboa Centro',
  ),
  Propriedade(
    title: 'Moradia com Piscina',
    type: 'T3',
    price: 380000,
    location: 'Cascais',
  ),
  Propriedade(
    title: 'Estúdio Renovado',
    type: 'T1',
    price: 150000,
    location: 'Porto',
  ),
  Propriedade(
    title: 'Apartamento Vista Mar',
    type: 'T2',
    price: 245000,
    location: 'Algarve',
  ),
];