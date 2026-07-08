import 'package:flutter/material.dart';

Widget buildStockSummaryDataTable(List<List<String>> rowData) {
  return Row(
    children: [
      Column(
        children: [
          SizedBox(
            width: 110,

            child: DataTable(
              border: TableBorder.all(),
              columns: const [DataColumn(label: Text(''))],
              rows: rowData.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(row[0], style: TextStyle(color: Colors.blue[900])),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),

      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(),
            columns: [
              const DataColumn(
                label: Text(
                  '180 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '375 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '750 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '1000 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  'TOTAL',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'RUPEES',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
            rows: rowData.map((row) {
              return DataRow(cells: _buildDataCells(row.sublist(1)));
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

Widget buildStockSummaryDataTableIMFL(List<List<String>> rowData) {
  return Row(
    children: [
      Column(
        children: [
          SizedBox(
            width: 130,

            child: DataTable(
              border: TableBorder.all(),
              columns: const [DataColumn(label: Text(''))],
              rows: rowData.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(row[0], style: TextStyle(color: Colors.blue[900])),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),

      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(),
            columns: [
              const DataColumn(
                label: Text(
                  '180 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '375 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '750 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '1000 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  'TOTAL',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'RUPEES',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
            rows: rowData.map((row) {
              return DataRow(cells: _buildDataCells(row.sublist(1)));
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

Widget buildBeerStockSummaryDataTable(List<List<String>> rowData) {
  return Row(
    children: [
      Column(
        children: [
          SizedBox(
            width: 130,

            child: DataTable(
              border: TableBorder.all(),
              columns: const [DataColumn(label: Text(''))],
              rows: rowData.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(row[0], style: TextStyle(color: Colors.blue[900])),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(),
            columns: [
              const DataColumn(
                label: Text(
                  '650 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '500 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '325 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  'TOTAL',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'RUPEES',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],

            rows: rowData.map((row) {
              return DataRow(cells: _buildBeerDataCells(row.sublist(1)));
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

Widget buildImflAndBeerStockSummaryDataTable(List<List<String>> rowData) {
  return Row(
    children: [
      Column(
        children: [
          SizedBox(
            width: 130,

            child: DataTable(
              border: TableBorder.all(),
              columns: const [DataColumn(label: Text(''))],
              rows: rowData.map((row) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(row[0], style: TextStyle(color: Colors.blue[900])),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
      Expanded(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            border: TableBorder.all(),
            columns: [
              const DataColumn(
                label: Text(
                  '180 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              const DataColumn(
                label: Text(
                  '375 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),

              const DataColumn(
                label: Text(
                  '750 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purpleAccent,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '1000 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '650 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '500 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  '325 ml',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
              const DataColumn(
                label: Text(
                  'TOTAL',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              DataColumn(
                label: Text(
                  'RUPEES',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
            ],
            rows: rowData.map((row) {
              return DataRow(cells: _buildImflAndBeerDataCells(row.sublist(1)));
            }).toList(),
          ),
        ),
      ),
    ],
  );
}

List<DataCell> _buildDataCells(List<String> cells) {
  return cells.asMap().entries.map((entry) {
    int index = entry.key + 1;
    String cell = entry.value;

    Color cellColor;
    switch (index) {
      case 0:
        cellColor = Colors.blue[900]!;
        break;
      case 1:
        cellColor = Colors.blue;
        break;
      case 2:
        cellColor = Colors.green;
        break;
      case 3:
        cellColor = Colors.purple;
        break;
      case 4:
        cellColor = Colors.pink;
        break;
      case 5:
        cellColor = Colors.black;
        break;
      default:
        cellColor = Colors.blue[900]!;
    }

    return DataCell(
      Text(
        int.parse(cell).isNegative ? '0' : cell,
        style: TextStyle(color: cellColor),
      ),
    );
  }).toList();
}

List<DataCell> _buildBeerDataCells(List<String> cells) {
  return cells.asMap().entries.map((entry) {
    int index = entry.key + 1;
    String cell = entry.value;

    Color cellColor;
    switch (index) {
      case 0:
        cellColor = Colors.red;
        break;
      case 1:
        cellColor = Colors.teal;
        break;
      case 2:
        cellColor = Colors.orange;
        break;
      case 3:
        cellColor = Colors.deepOrange;
        break;
      case 4:
        cellColor = Colors.black;
        break;
      default:
        cellColor = Colors.blue[900]!;
    }

    return DataCell(
      Text(
        int.parse(cell).isNegative ? '0' : cell,
        style: TextStyle(color: cellColor),
      ),
    );
  }).toList();
}

List<DataCell> _buildImflAndBeerDataCells(List<String> cells) {
  return cells.asMap().entries.map((entry) {
    int index = entry.key + 1;
    String cell = entry.value;

    Color cellColor;
    switch (index) {
      case 0:
        cellColor = Colors.blue[900]!;
        break;
      case 1:
        cellColor = Colors.blue;
        break;
      case 2:
        cellColor = Colors.green;
        break;
      case 3:
        cellColor = Colors.purple;
        break;
      case 4:
        cellColor = Colors.pink;
        break;
      case 5:
        cellColor = Colors.teal;
        break;
      case 6:
        cellColor = Colors.orange;
        break;
      case 7:
        cellColor = Colors.deepOrange;
        break;
      case 8:
        cellColor = Colors.black;
        break;
      default:
        cellColor = Colors.blue[900]!;
    }

    return DataCell(
      Text(
        int.parse(cell).isNegative ? '0' : cell,
        style: TextStyle(color: cellColor),
      ),
    );
  }).toList();
}
