# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a design patterns learning repository. The only file is `design_patterns_learning_outline.md` — a structured study guide covering the GoF 23 design patterns in Chinese.

## Code Architecture

The document follows a 6-stage learning curriculum:

1. **Basics** — SOLID principles, UML class diagrams
2. **Creational** (5 patterns) — Singleton, Factory Method, Abstract Factory, Builder, Prototype
3. **Structural** (7 patterns) — Adapter, Bridge, Composite, Decorator, Facade, Flyweight, Proxy
4. **Behavioral** (10 patterns) — Chain of Responsibility, Command, Iterator, Mediator, Memento, Observer, State, Strategy, Template Method, Visitor
5. **Advanced** — Pattern comparisons, anti-patterns, architectural applications
6. **Practice** — Exercises, reading list, self-assessment checklist

Examples are provided in C# throughout.

## Adding New Pattern Documentation

When adding a new pattern section, follow the established structure:
- **Intent** — one-line purpose
- **Structure** — class/component roles
- **Code example** — preferably C# (consistent with existing examples)
- **Application scenarios**
- **Comparison** — how it differs from similar patterns
