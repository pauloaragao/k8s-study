const express = require('express');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.static('public'));
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// API to convert temperature
app.post('/api/convert', (req, res) => {
  const { temperature, fromUnit, toUnit } = req.body;
  
  if (!temperature || isNaN(temperature)) {
    return res.status(400).json({ error: 'Invalid temperature value' });
  }

  const temp = parseFloat(temperature);
  let result;

  try {
    if (fromUnit === toUnit) {
      result = temp;
    } else if (fromUnit === 'C' && toUnit === 'F') {
      result = (temp * 9/5) + 32;
    } else if (fromUnit === 'C' && toUnit === 'K') {
      result = temp + 273.15;
    } else if (fromUnit === 'F' && toUnit === 'C') {
      result = (temp - 32) * 5/9;
    } else if (fromUnit === 'F' && toUnit === 'K') {
      result = (temp - 32) * 5/9 + 273.15;
    } else if (fromUnit === 'K' && toUnit === 'C') {
      result = temp - 273.15;
    } else if (fromUnit === 'K' && toUnit === 'F') {
      result = (temp - 273.15) * 9/5 + 32;
    } else {
      throw new Error('Invalid units');
    }

    res.json({ 
      success: true, 
      result: parseFloat(result.toFixed(2)) 
    });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`Temperature Converter App running on http://localhost:${PORT}`);
});
