import '../modelos/cliente.dart';
import '../modelos/propriedade.dart';

final List<Cliente> clientes = [
  Cliente(
    nome: 'André Brito',
    tipologia: 'T2',
    orcamentoMinimo: 200000,
    orcamentoMaximo: 250000,
    localizacao: 'Lisboa Centro',
    garagem: 'Sim',
    piscina: 'Indiferente',
  ),
  Cliente(
    nome: 'David Costa',
    tipologia: 'T3',
    orcamentoMinimo: 300000,
    orcamentoMaximo: 400000,
    localizacao: 'Cascais',
    garagem: 'Sim',
    piscina: 'Sim',
  ),
  Cliente(
    nome: 'Carlos Oliveira',
    tipologia: 'T1',
    orcamentoMinimo: 120000,
    orcamentoMaximo: 180000,
    localizacao: 'Porto',
    garagem: 'Indiferente',
    piscina: 'Indiferente',
  ),
];

final List<Propriedade> propriedades = [
  Propriedade(
    preco: 230000,
    tipologia: 'T2',
    localizacao: 'Lisboa Centro',
    area: '85',
    garagem: 'Sim',
    piscina: 'Nao',
  ),
  Propriedade(
    preco: 380000,
    tipologia: 'T3',
    localizacao: 'Cascais',
    area: '140',
    garagem: 'Sim',
    piscina: 'Sim',
  ),
  Propriedade(
    preco: 150000,
    tipologia: 'T1',
    localizacao: 'Porto',
    area: '55',
    garagem: 'Nao',
    piscina: 'Nao',
  ),
  Propriedade(
    preco: 245000,
    tipologia: 'T2',
    localizacao: 'Algarve',
    area: '90',
    garagem: 'Sim',
    piscina: 'Sim',
  ),
];