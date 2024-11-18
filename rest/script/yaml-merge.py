import sys
import yaml

def extract_prefixed_paths(data, prefix, path=None, result=None):
    if isinstance(data, (dict, list)):  # Check if the data is a dictionary or list
        if isinstance(data, dict):
            items = data.items()
        else:  # For lists, enumerate to get index and item
            items = enumerate(data)

        if path is not None and result is None:
            for pathKey in path:
                for key, value in items:
                    if pathKey == key:
                        items = value.items()
                        break
                else:
                    raise Exception("Key '%s' not found in first file." % pathKey)

        if result is None:
            result = {}
        if path is None:
            path = []

        for key, value in items:
            current_path = path + [key]
            if isinstance(key, str) and (prefix is None or key.startswith(prefix)):
                result[tuple(current_path)] = value
            extract_prefixed_paths(value, prefix, current_path, result)

    return result

def update_second_file(paths, second_data):
    for path, value in paths.items():
        try:
            ref = second_data
            for key in path[:-1]:
                ref = ref[key]
            ref[path[-1]] = value  # Set the value at the final path segment
        except (KeyError, IndexError) as e:
            raise Exception(f"Path [{', '.join(map(str, path[:-1]))}] not found in second file.")

def main():
    if len(sys.argv) < 4:
        print("Usage: python %s <file_path_1> <file_path_2> <key prefix or path prefix]" % sys.argv[0])
        sys.exit(1)
    file_path_1, file_path_2, prefix = sys.argv[1], sys.argv[2], sys.argv[3]
    if prefix.startswith("/"):
        path = prefix.split("/")[1:]
        prefix = None
    else:
        path = None

    with open(file_path_1, 'r') as file1:
        data1 = yaml.safe_load(file1)
        paths = extract_prefixed_paths(data1, prefix, path)

    with open(file_path_2, 'r') as file2:
        data2 = yaml.safe_load(file2)

    update_second_file(paths, data2)

    yaml.safe_dump(data2, sys.stdout)

if __name__ == "__main__":
    main()
