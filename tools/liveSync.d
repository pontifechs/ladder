#! /usr/bin/env rdmd


import std.stdio;
import std.process;
import std.regex;
import std.conv;

int main(string[] args)
{
    if (args.length < 3)
    {
        writeln("Usage: ./liveSync.d path/to/source path/to/destination");
        return 1;
    }
    string source = args[1], dest = args[2]; 

    syncDirectories(source, dest);

    auto inotify = ["inotifywait", "-r", "-m", "-e", "modify", "--format", "%w%f", source];
    auto pipes = pipeProcess(inotify, Redirect.stdout);

    auto sourceRoot = regex("^" ~ source);

    foreach (line; pipes.stdout.byLine)
    {
        auto sourcePath = to!string(line);
        syncFile(sourcePath, replaceAll(sourcePath, sourceRoot, dest));
    }
    return 0;
}

void syncFile(string source, string destination)
{
    auto install = ["install", "-D", "-p", "--mode=a=r", source, destination];
    auto pid = spawnProcess(install);
    wait(pid);
    writeln(source ~ " -> " ~ destination);
}

void syncDirectories(string source, string destination)
{
    auto rsync = ["rsync", "-ar", source, destination];
    auto pid = spawnProcess(rsync);
    wait(pid);
    writeln("Synchronizing " ~ source ~ " to " ~ destination);
}

