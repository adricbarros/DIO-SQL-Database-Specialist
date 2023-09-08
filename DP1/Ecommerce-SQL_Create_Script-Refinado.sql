-- MySQL Script generated by MySQL Workbench
-- Thu Sep  7 21:07:50 2023
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ecommerce
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 ;
USE `ecommerce` ;

-- -----------------------------------------------------
-- Table `ecommerce`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Cliente` (
  `idCliente` INT NOT NULL AUTO_INCREMENT,
  `CPF_CNPJ` VARCHAR(14) NOT NULL COMMENT 'Atributo de tamanho variavel de ate 14 caracteres, suficiente para inserção dos dados de CPF(11) ou CNPJ(14).\nA Aplicação deverá ler o tamanho do dado inserido, 11 ou 14 caracteres, e uma vez distinguido,  validar se o valor inserido está correto.\n',
  `Nome` VARCHAR(45) NOT NULL,
  `Nasc_fundação` DATE NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `CEP` VARCHAR(9) NOT NULL,
  `UF` CHAR(2) NOT NULL,
  `Telefone` VARCHAR(9) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idCliente`),
  UNIQUE INDEX `CPF_CNPJ_UNIQUE` (`CPF_CNPJ` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Pedido` (
  `idPedido` INT NOT NULL AUTO_INCREMENT,
  `Status` VARCHAR(45) NOT NULL,
  `Descrição` VARCHAR(45) NOT NULL,
  `Valor Frete` FLOAT NOT NULL,
  `Valor Total` FLOAT NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idPedido`, `Cliente_idCliente`),
  INDEX `fk_Pedido_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `ecommerce`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto` (
  `idProduto` INT NOT NULL AUTO_INCREMENT,
  `Categoria` VARCHAR(45) NOT NULL,
  `Descrição` VARCHAR(45) NOT NULL,
  `Valor` VARCHAR(45) NOT NULL,
  `Fabricante` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idProduto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `CNPJ` VARCHAR(45) NOT NULL,
  `Razao Social` VARCHAR(45) NOT NULL,
  `Data_abertura` DATE NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `UF` CHAR(2) NOT NULL,
  `CEP` CHAR(9) NOT NULL,
  `Telefone` VARCHAR(9) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  `Responsavel` VARCHAR(45) NOT NULL,
  `Categoria` ENUM('Bens', 'Serviços') NOT NULL COMMENT 'Fornecedor pode fornecer produtos ou serviços',
  PRIMARY KEY (`idFornecedor`),
  UNIQUE INDEX `CNPJ_UNIQUE` (`CNPJ` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Disponibilizando um produto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Disponibilizando um produto` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Produto_idProduto`),
  INDEX `fk_Fornecedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Produto_Fornecedor_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Produto_Fornecedor`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `ecommerce`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Estoque` (
  `idEstoque` INT NOT NULL AUTO_INCREMENT,
  `Cidade` VARCHAR(45) NOT NULL,
  `UF` CHAR(2) NOT NULL,
  PRIMARY KEY (`idEstoque`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Produto_has_Estoque`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produto_has_Estoque` (
  `Produto_idProduto` INT NOT NULL,
  `Estoque_idEstoque` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Estoque_idEstoque`),
  INDEX `fk_Produto_has_Estoque_Estoque1_idx` (`Estoque_idEstoque` ASC) VISIBLE,
  INDEX `fk_Produto_has_Estoque_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Estoque_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Estoque_Estoque1`
    FOREIGN KEY (`Estoque_idEstoque`)
    REFERENCES `ecommerce`.`Estoque` (`idEstoque`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Relação Produto/Pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Relação Produto/Pedido` (
  `Produto_idProduto` INT NOT NULL,
  `Pedido_idPedido` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`Produto_idProduto`, `Pedido_idPedido`),
  INDEX `fk_Produto_has_Pedido_Pedido1_idx` (`Pedido_idPedido` ASC) VISIBLE,
  INDEX `fk_Produto_has_Pedido_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  CONSTRAINT `fk_Produto_has_Pedido_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Produto_has_Pedido_Pedido1`
    FOREIGN KEY (`Pedido_idPedido`)
    REFERENCES `ecommerce`.`Pedido` (`idPedido`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Terceiro - Vendedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Terceiro - Vendedor` (
  `idTerceiro - Vendedor` INT NOT NULL AUTO_INCREMENT,
  `CNPJ` VARCHAR(14) NOT NULL,
  `Razao Social` VARCHAR(45) NOT NULL,
  `Endereço` VARCHAR(45) NOT NULL,
  `Cidade` VARCHAR(45) NOT NULL,
  `CEP` CHAR(9) NOT NULL,
  `UF` CHAR(2) NOT NULL,
  `Telefone` VARCHAR(9) NOT NULL,
  `Email` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idTerceiro - Vendedor`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Produtos por Vendedor (Terceiro)`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Produtos por Vendedor (Terceiro)` (
  `Terceiro - Vendedor_idTerceiro - Vendedor` INT NOT NULL,
  `Produto_idProduto` INT NOT NULL,
  `Quantidade` INT NULL,
  PRIMARY KEY (`Terceiro - Vendedor_idTerceiro - Vendedor`, `Produto_idProduto`),
  INDEX `fk_Terceiro - Vendedor_has_Produto_Produto1_idx` (`Produto_idProduto` ASC) VISIBLE,
  INDEX `fk_Terceiro - Vendedor_has_Produto_Terceiro - Vendedor1_idx` (`Terceiro - Vendedor_idTerceiro - Vendedor` ASC) VISIBLE,
  CONSTRAINT `fk_Terceiro - Vendedor_has_Produto_Terceiro - Vendedor1`
    FOREIGN KEY (`Terceiro - Vendedor_idTerceiro - Vendedor`)
    REFERENCES `ecommerce`.`Terceiro - Vendedor` (`idTerceiro - Vendedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Terceiro - Vendedor_has_Produto_Produto1`
    FOREIGN KEY (`Produto_idProduto`)
    REFERENCES `ecommerce`.`Produto` (`idProduto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Cartões`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Cartões` (
  `idCartões` INT NOT NULL AUTO_INCREMENT,
  `Titular` VARCHAR(45) NOT NULL,
  `Numero` VARCHAR(16) NOT NULL,
  `Validade` VARCHAR(45) NOT NULL,
  `Bandeira` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`idCartões`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Entrega` (
  `idEntrega` INT NOT NULL AUTO_INCREMENT,
  `Status` VARCHAR(20) NULL,
  `Codigo de Rastreio` VARCHAR(20) NULL,
  PRIMARY KEY (`idEntrega`),
  UNIQUE INDEX `Codigo de Rastreio_UNIQUE` (`Codigo de Rastreio` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Cartões_has_Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Cartões_has_Cliente` (
  `Cartões_idCartões` INT NOT NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`Cartões_idCartões`, `Cliente_idCliente`),
  INDEX `fk_Cartões_has_Cliente_Cliente1_idx` (`Cliente_idCliente` ASC) VISIBLE,
  INDEX `fk_Cartões_has_Cliente_Cartões1_idx` (`Cartões_idCartões` ASC) VISIBLE,
  CONSTRAINT `fk_Cartões_has_Cliente_Cartões1`
    FOREIGN KEY (`Cartões_idCartões`)
    REFERENCES `ecommerce`.`Cartões` (`idCartões`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cartões_has_Cliente_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `ecommerce`.`Cliente` (`idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Relação Pedido/Entrega`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Relação Pedido/Entrega` (
  `Pedido_idPedido` INT NOT NULL,
  `Pedido_Cliente_idCliente` INT NOT NULL,
  `Entrega_idEntrega` INT NOT NULL,
  PRIMARY KEY (`Pedido_idPedido`, `Pedido_Cliente_idCliente`, `Entrega_idEntrega`),
  INDEX `fk_Pedido_has_Entrega_Entrega1_idx` (`Entrega_idEntrega` ASC) VISIBLE,
  INDEX `fk_Pedido_has_Entrega_Pedido1_idx` (`Pedido_idPedido` ASC, `Pedido_Cliente_idCliente` ASC) VISIBLE,
  CONSTRAINT `fk_Pedido_has_Entrega_Pedido1`
    FOREIGN KEY (`Pedido_idPedido` , `Pedido_Cliente_idCliente`)
    REFERENCES `ecommerce`.`Pedido` (`idPedido` , `Cliente_idCliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pedido_has_Entrega_Entrega1`
    FOREIGN KEY (`Entrega_idEntrega`)
    REFERENCES `ecommerce`.`Entrega` (`idEntrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ecommerce`.`Relação Frete/Transportadora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ecommerce`.`Relação Frete/Transportadora` (
  `Fornecedor_idFornecedor` INT NOT NULL,
  `Entrega_idEntrega` INT NOT NULL,
  PRIMARY KEY (`Fornecedor_idFornecedor`, `Entrega_idEntrega`),
  INDEX `fk_Fornecedor_has_Entrega_Entrega1_idx` (`Entrega_idEntrega` ASC) VISIBLE,
  INDEX `fk_Fornecedor_has_Entrega_Fornecedor1_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_has_Entrega_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `ecommerce`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Fornecedor_has_Entrega_Entrega1`
    FOREIGN KEY (`Entrega_idEntrega`)
    REFERENCES `ecommerce`.`Entrega` (`idEntrega`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;