#! /usr/bin/env rdmd


import std.stdio;
import std.process;
import std.regex;
import std.conv;
import std.getopt;



int main(string[] args)
{
    string extension = `.*`;
    getopt(
        args,
        "extension|x", &extension
    );
   
    if (args.length < 3)
    {
        writeln("Usage: ./liveSync.d path/to/source path/to/destination");
        return 1;
    }
    string source = args[1], dest = args[2]; 

    //syncDirectories(source, dest, extension);

    auto inotify = ["inotifywait", "-r", "-m", "-e", "modify", "--format", "%w%f", source];
    auto pipes = pipeProcess(inotify, Redirect.stdout);

    auto sourceRoot = regex("^" ~ source);
    auto extensionPattern = regex(`\.` ~ extension ~ "$");

    foreach (line; pipes.stdout.byLine)
    {
        auto sourcePath = to!string(line);

        if (!match(sourcePath, extensionPattern)) { continue; }
        
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

void syncDirectories(string source, string destination, string extension)
{
    auto include = "--include='*."~extension~"'$";
    auto includeSub = "--include='*/'";
    auto excludeRemainder = "--exclude='*'";

    auto rsync = ["rsync", "-am", include, includeSub, excludeRemainder, source, destination];
    auto pid = spawnProcess(rsync);
    wait(pid);
    writeln("Synchronizing " ~ source ~ " to " ~ destination);
}

