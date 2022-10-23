<div align="center">

<h1>PX-DOS drivers</h1>
<h1>Drivers do PX-DOS</h3>

![](https://img.shields.io/github/license/felipenlunkes/PX-DOS-Drivers.svg)
![](https://img.shields.io/github/stars/felipenlunkes/PX-DOS-Drivers.svg)
![](https://img.shields.io/github/issues/felipenlunkes/PX-DOS-Drivers.svg)
![](https://img.shields.io/github/issues-closed/felipenlunkes/PX-DOS-Drivers.svg)
![](https://img.shields.io/github/issues-pr/felipenlunkes/PX-DOS-Drivers.svg)
![](https://img.shields.io/github/issues-pr-closed/felipenlunkes/PX-DOS-Drivers.svg)
![](https://img.shields.io/github/downloads/felipenlunkes/PX-DOS-Drivers/total.svg)
![](https://img.shields.io/github/release/felipenlunkes/PX-DOS-Drivers.svg)

</div>

<hr>

# Repositories/Repositórios

<div align="center">
  
[![PX-DOS Kernel](https://github-readme-stats.vercel.app/api/pin/?username=felipenlunkes&repo=PX-DOS&theme=dark)](https://github.com/felipenlunkes/PX-DOS)
[![PX-DOS Drivers](https://github-readme-stats.vercel.app/api/pin/?username=felipenlunkes&repo=PX-DOS-Drivers&theme=dark)](https://github.com/felipenlunkes/PX-DOS-Drivers)
[![PX-DOS Init](https://github-readme-stats.vercel.app/api/pin/?username=felipenlunkes&repo=PX-DOS-init&theme=dark)](https://github.com/felipenlunkes/PX-DOS-init)
[![PX-DOS libc](https://github-readme-stats.vercel.app/api/pin/?username=felipenlunkes&repo=PX-DOS-libc&theme=dark)](https://github.com/felipenlunkes/PX-DOS-libc)
[![PX-DOS Apps](https://github-readme-stats.vercel.app/api/pin/?username=felipenlunkes&repo=PX-DOS-Apps&theme=dark)](https://github.com/felipenlunkes/PX-DOS-Apps)
[![PX-DOS libasm](https://github-readme-stats.vercel.app/api/pin/?username=felipenlunkes&repo=PX-DOS-libasm&theme=dark)](https://github.com/felipenlunkes/PX-DOS-libasm)

</div>

# English

<div align="justify">

[PX-DOS](https://github.com/felipenlunkes/PX-DOS) is derived from an older version of a DOS system, the [Public Domain Operating System](http://www.pdos.org/) (PDOS). PX-DOS adds new layers, abstractions and functions on top of PDOS and extends its functionality. Also added a number of new utilities (userland) to the base system.

</div>

### Dependencies needed to build PX-DOS drivers

<div align="justify">

To build PX-DOS drivers, you will need the following dependencies:

</div>

<div align="center">

![Windows](https://img.shields.io/badge/Windows_32_bit-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![NASM](https://img.shields.io/badge/NASM-0C322C?style=for-the-badge&logo=assembly&logoColor=white)

</div>

<div align="justify">

You cannot start the process without these dependencies installed. The dependencies listed above can only run on 32-bit versions of Windows NT (or on virtual machines with some 32-bit version of Windows installed). Make sure the path to the dependencies' executables is declared in %PATH%.

After all dependencies are installed, you can proceed with this tutorial.

</div>

### Drivers

<div align="justify">

The Drivers can be built by running the file *.exe, present in each directory or using:

```
nasm -f bin driver.asm -o driver.sis
``

</div>

# Português

### O PX-DOS

<div align="justify">

[PX-DOS](https://github.com/felipenlunkes/PX-DOS) é derivado de uma versão mais antiga de um sistema DOS, o [Public Domain Operating System](http://www.pdos.org/) (PDOS). O PX-DOS adiciona novas camadas, abstrações e funções sobre o PDOS e estende sua funcionalidade. Também foram adicionados vários novos utilitários (userland) ao sistema básico.

</div>
  
### Dependências necessárias à construção dos drivers do PX-DOS

<div align="justify">

Para construir os drivers do PX-DOS, você vai precisar das seguintes dependências:

</div>

<div align="center">

![Windows](https://img.shields.io/badge/Windows_32_bit-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![NASM](https://img.shields.io/badge/NASM-0C322C?style=for-the-badge&logo=assembly&logoColor=white)

</div>

<div align="justify">

Você não pode iniciar o processo sem essas dependências instaladas. As dependências listadas acima só podem ser executadas sobre versões do Windows NT de 32-bit (ou em máquinas virtuais com alguma versão do Windows de 32-bit instalada). Tenha certexa que o caminho para os executáveis das dependências estejam declarados em %PATH%.

Após a instalação de todas as dependências, você poderá seguir com este tutorial.

</div>

### Drivers

<div align="justify">

Os drivers pode ser construídos executando os arquivos *.exe presentes em cada diretório, ou:

```
nasm -f bin driver.asm -o driver.sis
```

</div>

<!-- Versão do arquivo: 1.0
Copyright © 2012-2022 Felipe Miguel Nery Lunkes
-->
