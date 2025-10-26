
import { Controller } from "@hotwired/stimulus"

import { Chart, registerables } from "chart.js";
Chart.register(...registerables);

export default class extends Controller {
    static targets = ['highestAttemptsChart'];
    static values = {
        labels: Array,
        highestAttempts: Array,
        unit: String
    };

    canvasContext() {
        return this.highestAttemptsChartTarget.getContext('2d');
    };

    connect() {

        console.log(this.highestAttemptsValue)
        new Chart(this.canvasContext(), {
            type: 'line',
            data: {
                labels: this.labelsValue,
                datasets: [
                    {
                        label: `Highest attempt (${this.unitValue})`,
                        data: this.highestAttemptsValue,
                        borderWidth: 1,
                        borderColor: '#FF4B33',
                    }
                ]
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
