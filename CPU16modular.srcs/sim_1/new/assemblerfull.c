#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int reg_num(const char *r)
{
    if (r == NULL || toupper((unsigned char)r[0]) != 'R')
        return -1;

    int n = atoi(r + 1);
    if (n < 0 || n > 7)
        return -1;

    return n;
}

void trim_comment(char *line)
{
    for (int i = 0; line[i]; i++)
    {
        if (line[i] == ';' || line[i] == '#')
        {
            line[i] = '\0';
            return;
        }
    }
}

int main(void)
{
    FILE *fin = fopen("E:\\vhdl programs\\CPU16modular\\CPU16modular.srcs\\sim_1\\new\\input.txt", "r");
    FILE *fout = fopen("E:\\vhdl programs\\CPU16modular\\CPU16modular.srcs\\sim_1\\new\\program.txt", "w");

    if (!fin)
    {
        printf("Cannot open input.txt\n");
        return 1;
    }

    if (!fout)
    {
        printf("Cannot create program.txt\n");
        fclose(fin);
        return 1;
    }

    char line[128];
    int line_no = 0;

    while (fgets(line, sizeof(line), fin))
    {
        line_no++;
        trim_comment(line);

        char op[20] = {0}, a[20] = {0}, b[20] = {0}, c[20] = {0};
        unsigned short instr = 0;

        int count = sscanf(line, "%19s %19s %19s %19s", op, a, b, c);
        if (count <= 0)
            continue;

        for (int i = 0; op[i]; i++)
            op[i] = toupper((unsigned char)op[i]);

        if (strcmp(op, "NOP") == 0)
        {
            instr = 0x0000;
        }
        else if (strcmp(op, "STOP") == 0)
        {
            instr = 0xF000;
        }
        else if (strcmp(op, "LOADI") == 0)
        {
            int rd = reg_num(a);
            int imm = atoi(b);

            if (rd < 0)
            {
                printf("Line %d: invalid register in LOADI\n", line_no);
                continue;
            }

            instr = (0x1 << 12) | (rd << 9) | (imm & 0xFF);
        }
        else if (strcmp(op, "ADD") == 0 || strcmp(op, "SUB") == 0 ||
                 strcmp(op, "AND") == 0 || strcmp(op, "OR") == 0 ||
                 strcmp(op, "XOR") == 0 || strcmp(op, "MUL") == 0 ||
                 strcmp(op, "MAC") == 0)
        {
            int rd = reg_num(a);
            int rs1 = reg_num(b);
            int rs2 = reg_num(c);
            int opcode = 0;

            if (rd < 0 || rs1 < 0 || rs2 < 0)
            {
                printf("Line %d: invalid register in %s\n", line_no, op);
                continue;
            }

            if      (strcmp(op, "ADD") == 0) opcode = 0x2;
            else if (strcmp(op, "SUB") == 0) opcode = 0x3;
            else if (strcmp(op, "AND") == 0) opcode = 0x4;
            else if (strcmp(op, "OR")  == 0) opcode = 0x5;
            else if (strcmp(op, "XOR") == 0) opcode = 0x6;
            else if (strcmp(op, "MUL") == 0) opcode = 0x7;
            else if (strcmp(op, "MAC") == 0) opcode = 0x8;

            instr = (opcode << 12) | (rd << 9) | (rs1 << 6) | (rs2 << 3);
        }
        else if (strcmp(op, "NN") == 0)
        {
            int rd = reg_num(a);
            if (rd < 0)
            {
                printf("Line %d: invalid register in NN\n", line_no);
                continue;
            }

            instr = (0x9 << 12) | (rd << 9);
        }
        else if (strcmp(op, "MATMUL") == 0)
        {
            int rd = reg_num(a);
            if (rd < 0)
            {
                printf("Line %d: invalid register in MATMUL\n", line_no);
                continue;
            }

            instr = (0xA << 12) | (rd << 9);
        }
        else if (strcmp(op, "MOV") == 0)
        {
            int rd = reg_num(a);
            int rs1 = reg_num(b);

            if (rd < 0 || rs1 < 0)
            {
                printf("Line %d: invalid register in MOV\n", line_no);
                continue;
            }

            instr = (0xB << 12) | (rd << 9) | (rs1 << 6);
        }
        else if (strcmp(op, "MAC2") == 0)
        {
            int rd = reg_num(a);
            int rs1 = reg_num(b);
            int rs2 = reg_num(c);

            if (rd < 0 || rs1 < 0 || rs2 < 0)
            {
                printf("Line %d: invalid register in MAC2\n", line_no);
                continue;
            }

            instr = (0xC << 12) | (rd << 9) | (rs1 << 6) | (rs2 << 3);
        }
        else
        {
            printf("Line %d: unknown instruction %s\n", line_no, op);
            continue;
        }

        fprintf(fout, "%04X\n", instr);
    }

    fclose(fin);
    fclose(fout);

    printf("Assembly complete -> program.txt generated\n");
    return 0;
}