---
layout: home
title: DCC 024 Programming Languages
nav_exclude: true
seo:
  type: Course
  name: Programming Languages
---

# {{ site.tagline }}
{: .mb-2 }
{{ site.description }}
{: .fs-6 .fw-300 }

{% if site.announcements %}
{{ site.announcements.last }}
[Avisos](announcements.md){: .btn .btn-outline .fs-3 }
{% endif %}

---

- [Plano de ensino](plan.pdf)
- Instructor:
  - [Haniel Barbosa](https://homepages.dcc.ufmg.br/~hbarbosa/), Office 4323, DCC, hbarbosa@dcc.ufmg.br
- Teaching assistant:
  - Tomaz Mascarenhas, tomgm1502@gmail.com

---

## Outline
{: .no_toc .text-delta }

1. TOC
{:toc}

---

{: .no_toc .mb-2 }

An overview of programming language concepts in three parts.
{: .fs-6 .fw-300 }

The purpose of this course is to study fundamentals concepts in programming
languages and major tools and techniques to implement them. This includes a
number of programming paradigms, namely: functional, imperative/object-oriented,
and logic, as well as general aspects such as syntax specification and informal
semantic models; binding and scoping; types and type systems; control
structures; data abstraction; procedural abstraction and parameter passing;
higher-order functions; and memory management. The course has a strong
implementation component, with three languages being covered:
[SML](http://www.smlnj.org/sml97.html), [Python](http://www.python.org/), and
[Prolog](http://www.swi-prolog.org/). No prior familiarity with these languages
is assumed in this course. Learning them will have the secondary effect of
exposing students to the different programming paradigms.

The different course topics are viewed below.

<!-- O curso de Introdução à Ciência de Dados (DCC212) do DCC-UFMG tem como -->
<!-- principal objetivo trazer para os discentes um conhecimento estatístico através -->
<!-- de um ponto de vista computacional. O curso é fortemente inspirado nas ofertas -->
<!-- chamadas de Data8 e Data100 da universidade de Berkeley. Tais ementas (Data8 e -->
<!-- Data100) foram adaptadas para a realidade de discentes da graduação da UFMG. Em -->
<!-- particular, foi levado em conta que na nossa grade, os discentes já passaram -->
<!-- por matérias como: Álgebra Linear Computacional e Probabilidade. -->

<!-- Abaixo descrevemos as 4 partes (5 se contar a introdução) do curso junto com os -->
<!-- resultados de aprendizado esperados em cada. Tal estrutura em móudlos permite -->
<!-- que o aprendizado possa ser feito de diferentes fomas como: -->

<!-- Uma visão de um livro de estatística: -->
<!-- ``` -->
<!-- Mod 1 - Mod 2 - Mod 3 - Mod 4 -->
<!-- ``` -->

<!-- Ou, uma visão mais focada em aprendizado de máquina. -->
<!-- ``` -->
<!-- Mod 1 - Mod 3 - Mod 4 - Mod 2 -->
<!-- ``` -->

# Topic 1: SML introduction

An introduction to functional programming and the Standard ML (SML) programming
language.

**Goals**

1. Getting acquainted with functional programming.
1. Learning to write simple programs in SML.

# Topic 2: Syntax and semantics of programming languages

PL concepts such as types and polymorphism, higher-order functions, scope and
binders, as well as formal notions of syntax and semantics.

# Topic 3: Implementing programming languages

An introduction to general concepts in implementing programming languages,
viewed from the point of view of the imperative, functional and object-oriented
paradigms.

# Topic 4: Logic programming

An introduction to logic programming and the Prolog programming language.

# Project

In the course project the students will exercise their knowledge on programming
language concepts to define an interpreter for an ML-style toy language.

# Bibliography

  1. [Modern Programming Languages: A Practical Introduction](http://www.webber-labs.com/mpl/) <br>
      Adam Webber.

  1. Additional reading materials will be made available on the course web site as needed.
