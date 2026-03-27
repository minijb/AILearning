#!/bin/bash
# 处理所有传入的文件
echo "共 $# 个文件"

while [ "$#" -gt 0 ]; do
    echo "处理文件: $1"
    shift  # 每次左移一位
done
