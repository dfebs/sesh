import { Controller } from "@hotwired/stimulus"

import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
    static targets = ['myChart'];
    static values = {
        labels: Array,
        numbers: Array,
        unit: String
    };

    canvasContext() {
        return this.myChartTarget.getContext('2d');
    };

    connect() {
        new Chart(this.canvasContext(), {
            type: 'line',
            data: {
                labels: this.labelsValue,
                datasets: [{
                    label: `Workout volume (${this.unitValue})`,
                    data: this.numbersValue,
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }
}
