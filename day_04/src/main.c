#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef DEFINES
#define DEFINES
#define INPUT_FILE "./tests/input.txt"
#define ARRAY_SIZE 4096
#define TRUE 1
#define FALSE 0
#endif

void main()
{
    FILE *file_ptr;

    file_ptr = fopen(INPUT_FILE, "r");
    if (file_ptr == NULL)
    {
        printf("Error opening file\n");
        exit(1);
    }

    // Read file and build array
    int *section_id = malloc(sizeof(int) * ARRAY_SIZE);
    char buffer[256];
    int i = 0;
    while (fgets(buffer, 256, file_ptr))
    {
        char *token = strtok(buffer, "-");
        while (token)
        {
            section_id[i] = atoi(token);
            token = strtok(NULL, ",");
            i++;
            section_id[i] = atoi(token);
            token = strtok(NULL, "-");
            i++;
        }
    }

    // // Display the array
    // for (int i = 0; i < ARRAY_SIZE; i++)
    // {
    //     if (section_id[i] != 0)
    //     {
    //         printf("%d ", section_id[i]);
    //         if (i % 4 == 3)
    //             printf("\n");
    //     }
    // }

    int fully_overlapped_count = 0;
    int partially_overlapped_count = 0;

    for (int i = 0; i < ARRAY_SIZE; i += 4)
    {
        if (section_id[i] == 0)
            break;

        // Find fully overlapped sections
        if ((section_id[i] >= section_id[i + 2] && section_id[i + 1] <= section_id[i + 3]) ||
            (section_id[i] <= section_id[i + 2] && section_id[i + 1] >= section_id[i + 3]))
        {
            // printf("Fully overlapping: %d %d, %d %d\n", section_id[i], section_id[i + 1], section_id[i + 2], section_id[i + 3]);
            fully_overlapped_count++;
        }

        // Find partially overlapped sections
        if (is_num_in_range(section_id[i], section_id[i + 2], section_id[i + 3]) ||
            is_num_in_range(section_id[i + 1], section_id[i + 2], section_id[i + 3]) ||
            is_num_in_range(section_id[i + 2], section_id[i], section_id[i + 1]) ||
            is_num_in_range(section_id[i + 3], section_id[i], section_id[i + 1]))
        {
            // printf("Partially overlapping: %d %d, %d %d\n", section_id[i], section_id[i + 1], section_id[i + 2], section_id[i + 3]);
            partially_overlapped_count++;
        }
    }

    printf("Fully overlapped count: %d\n", fully_overlapped_count);
    printf("Partially overlapped count: %d\n", partially_overlapped_count);

    // Clean up
    free(section_id);
    section_id = NULL;

    exit(0);
}

/// @brief Check if a number is within the range of two numbers
/// @param num The number to check
/// @param start The start of the range
/// @param end The end of the range
/// @return 1 if the number is in the range, 0 otherwise
int is_num_in_range(int num, int start, int end)
{
    if (num >= start && num <= end)
        return TRUE;

    return FALSE;
}