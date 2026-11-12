import '../models/product_model.dart';

class SampleProducts {
  static final List<ProductModel> sankarCatalog = [
    ProductModel(
      id: 101,
      title: 'Sankar High-Temp Cylinder Head Gasket',
      description:
          'Multi-layer steel (MLS) cylinder head gasket engineered with proprietary fluoroelastomer micro-coating. Guaranteed leak-free compression seal up to 350°C and 250 bar pressure for automotive and heavy diesel engines.',
      category: 'Automotive Sealing',
      price: 1850.00,
      discountPercentage: 10.0,
      rating: 4.8,
      stock: 45,
      brand: 'Sankar Sealing Systems',
      thumbnail: 'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1486262715619-67b85e0b08d3?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1581092160607-ee22621dd758?w=600&auto=format&fit=crop&q=80',
      ],
      warrantyInformation: '3 Years Sankar OEM Guarantee',
      shippingInformation: 'Dispatches within 24 hours from Chennai Hub',
      availabilityStatus: 'In Stock',
    ),
    ProductModel(
      id: 102,
      title: 'Sankar Precision CNC Carbide End Mill Set',
      description:
          'Set of 5 solid micro-grain tungsten carbide 4-flute end mills with TiAlN nanocoating. Designed for high-speed machining of hardened alloys, stainless steel, and aerospace titanium.',
      category: 'Machining & Tools',
      price: 3490.00,
      discountPercentage: 15.0,
      rating: 4.9,
      stock: 28,
      brand: 'Sankar Tools',
      thumbnail: 'https://images.unsplash.com/photo-1504917599217-d4dc5ebe6122?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1504917599217-d4dc5ebe6122?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1581092335397-9583fe92d232?w=600&auto=format&fit=crop&q=80',
      ],
      warrantyInformation: '1 Year Industrial Wear Warranty',
      shippingInformation: 'Express courier delivery available',
      availabilityStatus: 'In Stock',
    ),
    ProductModel(
      id: 103,
      title: 'Sankar Smart IoT Vibration Sensor Hub',
      description:
          'Wireless predictive maintenance 3-axis accelerometer and surface temperature telemetry node. Bluetooth 5.2 and LoRaWAN connectivity with real-time cloud analytics integration.',
      category: 'Smart Industrial IoT',
      price: 8999.00,
      discountPercentage: 12.0,
      rating: 4.7,
      stock: 14,
      brand: 'Sankar Digital',
      thumbnail: 'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1518770660439-4636190af475?w=600&auto=format&fit=crop&q=80',
      ],
      warrantyInformation: '2 Years Replacement Warranty',
      shippingInformation: 'Pre-calibrated and ready to deploy',
      availabilityStatus: 'In Stock',
    ),
    ProductModel(
      id: 104,
      title: 'Sankar Heavy-Duty Hydraulic O-Ring Kit',
      description:
          '400-piece universal metric fluorosilicone (FKM) and nitrile (NBR 90) O-ring assortment. Formulated for resistance against synthetic fuels, hydraulic fluids, and ozone degradation.',
      category: 'Automotive Sealing',
      price: 950.00,
      discountPercentage: 5.0,
      rating: 4.6,
      stock: 80,
      brand: 'Sankar Sealing Systems',
      thumbnail: 'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1581092162384-8987c1d64718?w=600&auto=format&fit=crop&q=80',
      ],
      warrantyInformation: 'Guaranteed 5-year shelf-life stability',
      shippingInformation: 'Standard delivery in 2-3 business days',
      availabilityStatus: 'In Stock',
    ),
    ProductModel(
      id: 105,
      title: 'Sankar Digital Laser Micrometer Gauge',
      description:
          'Ultra-precision non-contact laser optical micrometer with 0.1 micrometer resolution. Telemetry output via USB-C and IP67 splash-proof casing for assembly line quality inspection.',
      category: 'Machining & Tools',
      price: 12500.00,
      discountPercentage: 18.0,
      rating: 4.9,
      stock: 9,
      brand: 'Sankar Metrology',
      thumbnail: 'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1581092334651-ddf26d9a09d0?w=600&auto=format&fit=crop&q=80',
      ],
      warrantyInformation: 'Factory calibration certificate included',
      shippingInformation: 'Insured transit dispatch',
      availabilityStatus: 'Only 9 left',
    ),
    ProductModel(
      id: 106,
      title: 'Sankar Pro Industrial Noise-Cancelling Headset',
      description:
          '28dB SNR high-attenuation electronic earmuffs with active ambient sound monitoring and built-in hands-free radio intercom for manufacturing plant floors.',
      category: 'Safety & Equipment',
      price: 2450.00,
      discountPercentage: 8.0,
      rating: 4.5,
      stock: 35,
      brand: 'Sankar Safety',
      thumbnail: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
      ],
      warrantyInformation: '1 Year Industrial Standard Warranty',
      shippingInformation: 'Ships within 24 hours',
      availabilityStatus: 'In Stock',
    ),
  ];

  static final List<String> categories = [
    'All',
    'Automotive Sealing',
    'Machining & Tools',
    'Smart Industrial IoT',
    'Safety & Equipment',
    'Electronics',
  ];
}
