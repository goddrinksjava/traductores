package traductores;

public enum BasicSym {
  EOF(0),
  ERROR(1),
  SUMA(2),
  RESTA(3),
  MULTIPLICACION(4),
  DIVISION(5),
  RESIDUO(6),
  MAYOR(7),
  MENOR(8),
  MAYOR_IGUAL(9),
  MENOR_IGUAL(10),
  IGUAL(11),
  DIFERENTE(12),
  ASIGNACION(13),
  EXPONENTE(14),
  CONCAT(15),
  IF(16),
  THEN(17),
  ELSE(18),
  AND(19),
  OR(20),
  NOT(21),
  MATCH(22),
  REUSE(23),
  LET(24),
  DATA(25),
  READ(26),
  DIM(27),
  FOR(28),
  TO(29),
  NEXT(30),
  REPEAT(31),
  UNTIL(32),
  DO(33),
  LOOP(34),
  GOTO(35),
  GOSUB(36),
  RETURN(37),
  LIST(38),
  INPUT(39),
  PRINT(40),
  IDENTIFIER(41),
  STATEMENT_SEPARATOR(42),
  PL(43),
  PR(44),
  BL(45),
  BR(46),
  STRING_LITERAL(47),
  LABEL(48),
  SEPARATOR(49),
  INTEGER(50),
  FLOAT(51),
  CHAR(52),
  REMARK(53);

  private final int value;

  private BasicSym(int value) {
    this.value = value;
  }

  public int getValue() {
    return value;
  }
}
