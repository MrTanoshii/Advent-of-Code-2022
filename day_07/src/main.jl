mutable struct File
    name::String
    size::Int64

    # Constructor
    function File(name::String)
        new(name, 0)
    end

    # Constructor
    function File(name::String, size::Int64)
        new(name, size)
    end
end

mutable struct Dir
    name::String
    size::Int64
    totalsize::Int64
    parentdir::Union{Dir, Nothing}
    subdirs::Vector{Dir}
    files::Vector{File}

    # Constructor
    function Dir(name::String, size::Int64, totalsize::Int64, parentdir::Union{Dir, Nothing}, subdirs::Vector{Dir}, files::Vector{File})
        new(name, size, totalsize, parentdir, subdirs, files)
    end
end

function updatedirsize!(dir::Dir, size::Int64)
    currentdir = dir
    currentdir.size += size
    currentdir.totalsize += size

    while currentdir.parentdir != nothing
        currentdir = currentdir.parentdir
        currentdir.totalsize += size
    end
end

function addfile!(dir::Dir, file::File)
    push!(dir.files, file)
    updatedirsize!(dir, file.size)
end

function addsubdir!(dir::Dir, subdir::Dir)
    push!(dir.subdirs, subdir)
end

function getsubdir(dir::Dir, name::String)
    for subdir in dir.subdirs
        if subdir.name == name
            return subdir
        end
    end
    return nothing
end

function getdirfile(dir::Dir, name::String)
    for file in dir.files
        if file.name == name
            return file
        end
    end
    return nothing
end

function setfilesize(dir::Dir, name::String, size::Int64)
    file = getdirfile(dir, name)
    if file != nothing
        updatedirsize!(dir, size - file.size)
        file.size = size
    end
end

lines = String[]
rootdir = Dir("/", 0, 0, nothing, Dir[], File[])
currentdir = rootdir

# Read file and populate array
open("./data/input.dat") do file
    linenum = 0
    for line in eachline(file)
        linenum += 1
        push!(lines, line)
        # println("#$linenum | $line")
        # println(@show currentdir)

        if line[1] == '$' # Line contains command
            if line[3:4] == "cd" # Change directory
                if line[6] == '/' # Back to root dir
                    global currentdir = rootdir
                elseif (length(line) >= 7) && line[6:7] == ".." # Back to parent dir
                    global currentdir = currentdir.parentdir
                else # Move into subdirectory
                    if getsubdir(currentdir, line[6:end]) != nothing # Subdir already exists
                        global currentdir = getsubdir(currentdir, line[6:end])
                    else # Make new subdir
                        subdir = Dir(line[6:end], 0, 0, currentdir, Dir[], File[])
                        addsubdir!(currentdir, subdir)
                        global currentdir = subdir
                    end
                end
            elseif line[3:4] == "ls" # List
            end
        else # Line contains result
            if line[1:3] == "dir" # Result is a dir
                founddir = false
                for subdir in currentdir.subdirs
                    if subdir.name == line[5:end]
                        founddir = true
                        break
                    end
                end

                # Make new subdir if it doesn't exist
                if founddir == false
                    subdir = Dir(line[5:end], 0, 0, currentdir, Dir[], File[])
                    addsubdir!(currentdir, subdir)
                end
            else # Result is a file
                splitstr = split(line, " ")
                filesize = parse(Int64, splitstr[1])
                filename = String(splitstr[2])

                foundfile = false
                for file in currentdir.files
                    if file.name == filename
                        setfilesize(currentdir, filename, filesize)
                        foundfile = true
                        break
                    end
                end

                # Make new file if it doesn't exist
                if foundfile == false
                    file = File(filename, filesize)
                    addfile!(currentdir, file)
                end
            end
        end
    end
end

function listdirrecursive(dir::Dir, indent::Int64=0)
    for i in 1:indent
        print("  ")
    end
    println("Dir: $(dir.name) [$(dir.size) / $(dir.totalsize)]")
    for subdir in dir.subdirs
        listdirrecursive(subdir, indent + 1)
    end
    for file in dir.files
        for i in 1:indent+1
            print("  ")
        end
        println("File: $(file.name) [$(file.size)]")
    end
end

# println("Root dir size: $(rootdir.size)")
# listdirrecursive(rootdir)

function getsumdirtotalsizerecursive(dir::Dir, maxsize::Int64=0)
    sum = 0

    if dir.totalsize <= maxsize
        sum += dir.totalsize
        # println("Dir: $(dir.name) [$(dir.totalsize)] | Sum: $(sum)")
    end

    for subdir in dir.subdirs
        sum += getsumdirtotalsizerecursive(subdir, maxsize)
    end

    return sum
end

println("Sum of directories with total size less than 100,000: $(getsumdirtotalsizerecursive(rootdir, 100000))")

# PART 2

totalspace = 70000000
requiredspace = 30000000
spacetofree = rootdir.totalsize - (totalspace - requiredspace)

function getdirsizeclosestrecursive(dir::Dir, spacetofree::Int64, closestsize::Int64)
    result = closestsize
    
    if dir.totalsize >= spacetofree && dir.totalsize < result
        # println("Space to free: $(spacetofree) | Closest size: $(closestsize) | Dir: $(dir.name) [$(dir.totalsize)]")
        result = dir.totalsize
    end

    for subdir in dir.subdirs
        dirsize = getdirsizeclosestrecursive(subdir, spacetofree, result)
        if dirsize >= spacetofree && dirsize < result
            result = dirsize
        end
    end

    return result
end

println("Size of directory closest to required space: $(getdirsizeclosestrecursive(rootdir, spacetofree, totalspace))")