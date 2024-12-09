import 'package:aoc2024/day.dart';

import 'util/utils.dart';

sealed class Block {}

final class FreeBlock extends Block {
  @override
  String toString() {
    return '.';
  }
}

final class FileBlock extends Block {
  final int id;
  FileBlock(this.id);

  @override
  String toString() {
    return id.toString();
  }
}

sealed class Memory {
  int get length;
}

final class FreeMemory extends Memory {
  @override
  final int length;

  FreeMemory(this.length);

  @override
  String toString() {
    return '.' * length;
  }
}

final class FileMemory extends Memory {
  final int id;
  @override
  final int length;

  FileMemory(this.id, this.length);

  @override
  String toString() {
    return id.toString() * length;
  }
}

class Day9 implements Day {
  Future<List<int>> readInput() async {
    final line = await readFileAsString('inputs/day9.txt');
    return line.trim().split('').map((e) => int.parse(e)).toList();
  }

  @override
  Future<int> part1() async {
    // Step 1. Read the input file
    final input = await readInput();

    // Step 2. Parse every single digit into a number of blocks,
    // assigning every even index in the input list an ascending
    // ID Every odd index is free space and has the ID ".".
    final blocks = <Block>[];
    for (int i = 0; i < input.length; i++) {
      final count = input[i];
      if (i % 2 == 0) {
        blocks.addAll(List.generate(count, (_) => FileBlock(i ~/ 2)));
      } else {
        blocks.addAll(List.generate(count, (_) => FreeBlock()));
      }
    }

    // Step 3. Swap File blocks from end with first free space
    int readIndex = 0;
    int swapIndex = blocks.length - 1;
    while (readIndex < swapIndex) {
      if (blocks[readIndex] is FreeBlock) {
        while (blocks[swapIndex] is FreeBlock) {
          swapIndex--;
        }
        final tmp = blocks[readIndex];
        blocks[readIndex] = blocks[swapIndex];
        blocks[swapIndex] = tmp;
      }
      readIndex++;
    }

    // Step 4. Compute checksum of file blocks.
    // Their index multiplied by their ID is the checksum.
    int totalChecksum = 0;
    for (int i = 0; i < blocks.length; i++) {
      if (blocks[i] is FileBlock) {
        final fileBlock = blocks[i] as FileBlock;
        totalChecksum += i * fileBlock.id;
      }
    }

    return totalChecksum;
  }

  @override
  Future<int> part2() async {
    // Step 1. Read the input file
    final input = await readInput();

    // Step 2. Parse every single digit into a memory segment of length
    // equal to the digit. Assign every even index in the input list an
    // ascending ID. Every odd index is free space and has the ID ".".
    final memory = <Memory>[];
    for (int i = 0; i < input.length; i++) {
      final count = input[i];
      if (i % 2 == 0) {
        memory.add(FileMemory(i ~/ 2, count));
      } else {
        memory.add(FreeMemory(count));
      }
    }
    // final highestIndex = input.length ~/ 2;

    // Step 3. Swap File blocks from end with first free space
    // and split free space into two segments if necessary.
    // For each file block, a scan is performed from the beginning
    // of the memory to find the first free space segment that fits.
    int swapIndex = memory.length - 1;

    while (swapIndex >= 0) {
      if (memory[swapIndex] is! FileMemory) {
        swapIndex--;
        continue;
      }
      int readIndex = 0;
      while (readIndex < swapIndex && readIndex < memory.length) {
        if (memory[readIndex] is! FreeMemory) {
          readIndex++;
          continue;
        }
        final freeMemory = memory[readIndex] as FreeMemory;
        final fileMemory = memory[swapIndex] as FileMemory;

        if (freeMemory.length == fileMemory.length) {
          memory[readIndex] = fileMemory;
          memory[swapIndex] = freeMemory;
          break;
        } else if (freeMemory.length > fileMemory.length) {
          memory[readIndex] = fileMemory;
          memory.insert(
              readIndex + 1, FreeMemory(freeMemory.length - fileMemory.length));
          readIndex++;
          swapIndex++;
          memory[swapIndex] = FreeMemory(fileMemory.length);
          break;
        } else {
          readIndex++;
        }
      }
      swapIndex--;
    }

    // Step 4. Compute checksum of file blocks.
    // Their index multiplied by their ID is the checksum.
    int totalChecksum = 0;
    int offset = 0;
    for (int i = 0; i < memory.length; i++) {
      if (memory[i] is FileMemory) {
        final fileBlock = memory[i] as FileMemory;
        for (int j = 0; j < fileBlock.length; j++) {
          totalChecksum += (offset + j) * fileBlock.id;
        }
      }
      offset += memory[i].length;
    }

    return totalChecksum;
  }
}
