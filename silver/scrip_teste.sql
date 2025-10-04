-- Script genérico para criar tabela de exemplo com 20 registros

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inserindo 20 dados de exemplo
INSERT INTO users (name, email) VALUES
('Alice Silva', 'alice@example.com'),
('Bruno Lima', 'bruno@example.com'),
('Carla Santos', 'carla@example.com'),
('Daniel Oliveira', 'daniel@example.com'),
('Eduarda Costa', 'eduarda@example.com'),
('Felipe Rocha', 'felipe@example.com'),
('Gabriela Mendes', 'gabriela@example.com'),
('Henrique Alves', 'henrique@example.com'),
('Isabela Ferreira', 'isabela@example.com'),
('João Pedro', 'joao@example.com'),
('Karina Souza', 'karina@example.com'),
('Lucas Martins', 'lucas@example.com'),
('Mariana Ribeiro', 'mariana@example.com'),
('Nicolas Barbosa', 'nicolas@example.com'),
('Olívia Lima', 'olivia@example.com'),
('Paulo Henrique', 'paulo@example.com'),
('Queila Andrade', 'queila@example.com'),
('Rafael Nogueira', 'rafael@example.com'),
('Sofia Cardoso', 'sofia@example.com'),
('Tiago Fernandes', 'tiago@example.com');
